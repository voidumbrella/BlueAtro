local function build_skill_box(key, vars, cost)
	local set = cost and "BlueAtro_EX" or "BlueAtro_Passive"

	local desc_nodes = {}
	localize({ type = "descriptions", key = key, set = set, nodes = desc_nodes, vars = vars or {} })

	local desc = {}
	for _, v in ipairs(desc_nodes) do
		desc[#desc + 1] = { n = G.UIT.R, config = { align = "cl" }, nodes = v }
	end

	local name = localize({ type = "name_text", key = key, set = set, name_nodes = {}, vars = {} })
	local name_node = {
		{
			n = G.UIT.O,
			config = {
				object = DynaText({
					string = { name },
					colours = {
						G.C.UI.TEXT_LIGHT,
					},
					maxw = 5,
					y_offset = -0.6,
					scale = 0.35,
				}),
			},
		},
	}

	return {
		n = G.UIT.R,
		config = { align = "cm", colour = HEX("FE5F55"), r = 0.1, padding = 0.05 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.05, r = 0.1 },
				nodes = name_node,
			},
			{
				n = G.UIT.R,
				config = {
					align = "cl",
					r = 0.1,
					padding = 0.05,
					colour = desc_nodes.background_colour or G.C.WHITE,
				},
				nodes = { { n = G.UIT.R, config = { align = "cm", padding = 0.03 }, nodes = desc } },
			},
		},
	}
end

-- Implementation of UI for Student cards
BlueAtro.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if not card then
		card = self:create_fake_card()
	end

	local target = {
		type = "descriptions",
		key = self.key,
		set = self.set,
		nodes = desc_nodes,
		vars = specific_vars or {},
	}
	local res = {}
	if self.loc_vars and type(self.loc_vars) == "function" then
		res = self:loc_vars(info_queue, card) or {}
		target.vars = res.vars or target.vars
		target.key = res.key or target.key
		target.set = res.set or target.set
		target.scale = res.scale
		target.text_colour = res.text_colour
	end

	if desc_nodes == full_UI_table.main and not full_UI_table.name then
		full_UI_table.name = localize({
			type = "name",
			set = self.set,
			key = self.key,
			nodes = full_UI_table.name,
			vars = res.name_vars or target.vars or {},
		})
		desc_nodes[#desc_nodes + 1] = {
			build_skill_box(self.blueatro_passive_key, target.vars),
			build_skill_box(self.blueatro_ex_key, target.vars, self.blueatro_ex_cost),
		}
	end
end

-- Add use button for Student cards
local _G_UIDEF_use_and_sell_buttons = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	local t = _G_UIDEF_use_and_sell_buttons(card)
	if t and t.nodes[1] and t.nodes[1].nodes[2] and card.config.center.blueatro_ex_use then
		table.insert(t.nodes[1].nodes[2].nodes, {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						maxw = 1.25,
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 1,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "blueatro_ex_use",
						func = "blueatro_ex_ready",
					},
					nodes = {
						{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
						{
							n = G.UIT.T,
							config = {
								text = localize("b_use"),
								colour = G.C.UI.TEXT_LIGHT,
								scale = 0.55,
								shadow = true,
							},
						},
					},
				},
			},
		})
	end
	return t
end

-- Checks whether a Student Joker can use its EX Skill.
G.FUNCS.blueatro_ex_ready = function(e)
	local card = e.config.ref_table
	-- Vanilla game checks
	-- Yoinked from Card:can_use_consumeable
	local valid_state = not (
			(G.play and #G.play.cards > 0)
			or G.CONTROLLER.locked
			or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
		)
		and G.STATE ~= G.STATES.HAND_PLAYED
		and G.STATE ~= G.STATES.DRAW_TO_HAND
		and G.STATE ~= G.STATES.PLAY_TAROT
	--
	-- Student specific checks
	local student_consents = card.area == G.jokers
		and not card.debuff
		and card.config.center.blueatro_ex_use
		and card.config.center.blueatro_ex_cost <= G.GAME.current_round.blueatro.cost_meter.cur
		and card.config.center:blueatro_ex_ready(card)

	if valid_state and student_consents then
		e.config.colour = G.C.RED
		e.config.button = "blueatro_ex_use"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- Makes a Student Joker use its EX Skill.
-- This does NOT check if the current game state is actually valid.
-- It's the responsibility of the caller to check that.
G.FUNCS.blueatro_ex_use = function(e, mute)
	local card = e.config.ref_table

	G.E_MANAGER:add_event(Event({
		func = function()
			e.disable_button = nil
			e.config.button = "blueatro_ex_use"
			return true
		end,
	}))

	if card.children.use_button then
		card.children.use_button:remove()
		card.children.use_button = nil
	end
	if card.children.sell_button then
		card.children.sell_button:remove()
		card.children.sell_button = nil
	end
	local meter = G.GAME.current_round.blueatro.cost_meter
	-- It's not the job of this function to check if this will go negative.
	-- That responsibility is on `G.FUNCS.blueatro_ex_ready`.
	meter.cur = meter.cur - card.config.center.blueatro_ex_cost
	card.config.center:blueatro_ex_use(card)
	card.area:remove_from_highlighted(card)
end
