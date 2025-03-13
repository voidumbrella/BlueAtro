BlueAtro = {}
-- Used for students because I'm lazy
BlueAtro.id_to_atlas_pos = function(id)
	return { x = id % 10, y = id / 10 }
end

SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32,
})

-- ========================= MAIN =========================

-- Hook to register custom fields when run starts.
local _Game_start_run = Game.start_run
function Game:start_run(args)
	_Game_start_run(self, args)

	self.blueatro_costbar = UIBox({
		definition = BlueAtro.create_UIBox_cost(),
		config = { align = "cr", offset = { x = -1, y = 0 }, major = G.ROOM_ATTACH, bond = "Weak" },
	})
	self.blueatro_costbar.states.visible = true

	-- Default values for cost regen
	print(self.GAME.blueatro_cost)
	self.GAME.blueatro_cost = self.GAME.blueatro_cost or 0
	print(self.GAME.blueatro_cost)
	self.GAME.blueatro_cost_str = self.GAME.blueatro_cost_str or "0"
	self.GAME.blueatro_cost_max = self.GAME.blueatro_cost_max or 10
	self.GAME.blueatro_cost_per_sec = self.GAME.blueatro_cost_per_sec or 0.5
end

-- Hook to delete custom fields when run ends.
local _Game_delete_run = Game.delete_run
function Game:delete_run(args)
	_Game_delete_run(self, args)
	if self.ROOM then
		if self.blueatro_costbar then
			self.blueatro_costbar:remove()
			self.blueatro_costbar = nil
		end
	end
	self.timer = nil
end

-- Initialize run-wide global variables
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.blueatro = {}
	ret.current_round.blueatro.yuzu_combo = { "High Card", "Three of a Kind", "Two Pair" }
	return ret
end

function SMODS.current_mod.reset_game_globals(run_start) end

-- Would it be better to Lovely patch this instead?
local _smods_calculate_context = SMODS.calculate_context
---@diagnostic disable-next-line: duplicate-set-field
SMODS.calculate_context = function(context, return_table)
	local ret = _smods_calculate_context(context, return_table)

	-- BEGIN: Update round-global variables after each hand scores
	if context.after then
		-- BEGIN: Yuzu's Combo
		local movelist = {
			"High Card",
			"Pair",
			"Two Pair",
			"Three of a Kind",
			"Straight",
			"Flush",
			"Full House",
			-- hands below omitted intentionally
			-- "Four of a Kind",
			-- "Straight Flush"
		}
		local next = pseudorandom_element(movelist, pseudoseed("yuzu_combo"))
		local yuzu_combo = G.GAME.current_round.blueatro.yuzu_combo
		table.remove(yuzu_combo, 1)
		yuzu_combo[#yuzu_combo + 1] = next
		--END: Nyan's Dash
	end
	-- END: Update round-global variables after each hand
end

---Modify the current cost held by given amount.
---@param delta number Change to the cost meter.
function BlueAtro.update_cost(delta)
	local last = G.GAME.blueatro_cost
	local cur = last + delta
	-- Incremented
	if math.floor(last) < math.floor(cur) then
		play_sound("chips1")
	end
	G.GAME.blueatro_cost = math.max(0, math.min(cur, G.GAME.blueatro_cost_max))

	G.GAME.blueatro_cost_str = tostring(math.floor(cur))
	local cost_UI = G.blueatro_costbar:get_UIE_by_ID("blueatro_costbar_UI")
	cost_UI.config.object:update()
	G.blueatro_costbar:recalculate()
end

function BlueAtro.create_UIBox_cost()
	return {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			r = 1,
			colour = lighten(G.C.BLUE, 0.25),
			shadow = true,
			minw = 1,
			maxw = 1,
			minh = 1,
			maxh = 1,
		},
		nodes = {
			{
				n = G.UIT.O,
				config = {
					id = "blueatro_costbar_UI",
					object = DynaText({
						string = {
							{
								ref_table = G.GAME,
								ref_value = "blueatro_cost_str",
							},
						},
						scale = 1,
						colours = { G.C.WHITE },
						bump_rate = 1,
						bump_amount = 2,
					}),
				},
			},
		},
	}
end

-- ========================= BLIND TIMER =========================
BlueAtro.BlindTimer = { real = 0, display = "" }
---Updates the current blind timer.
---If dt is nil, it will reset it to G.GAME.blind_timer_length instead.
---@param dt number?
function BlueAtro.update_blind_timer(dt)
	local timer = BlueAtro.BlindTimer
	if dt == nil then
		timer.real = G.GAME.blind_timer_length
	else
		timer.real = math.max(0, timer.real + dt)
	end
	-- I wish I could print floats with leading zeroes
	timer.display = string.format(
		"%d:%02d.%s",
		math.floor(timer.real / 60),
		math.floor(timer.real % 60),
		string.format("%.3f", timer.real % 1):sub(3)
	)
	if G.HUD_Blind then
		local timer_UI = G.HUD_blind:get_UIE_by_ID("blueatro_HUD_timer")
		if timer_UI then
			timer_UI.config.object:update()
			G.HUD_blind:recalculate()
		end
	end
end

local _Game_update = G.update
function Game:update(dt)
	_Game_update(self, dt)

	-- Game is not paused, and player actually has control.
	if not G.SETTINGS.paused and self.STATE == self.STATES.SELECTING_HAND then
		BlueAtro.update_cost(G.GAME.blueatro_cost_per_sec * dt)

		BlueAtro.update_blind_timer(-dt)
		if G.GAME.blind_timer.real == 0 then
			G.STATE = G.STATES.GAME_OVER
			if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
				G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
			end
			G:save_settings()
			G.FILE_HANDLER.force = true
			G.STATE_COMPLETE = false
		end
	end
end

local _create_UIBox_HUD_blind = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
	local ret = _create_UIBox_HUD_blind()
	ret.nodes[2].nodes[3] = {
		n = G.UIT.R,
		config = { align = "cm", minh = 0.7, r = 0.1, emboss = 0.05, colour = G.C.DYN_UI.MAIN },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", minw = 3 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText({
								string = { { ref_table = G.GAME.blind_timer, ref_value = "display" } },
								colours = { G.C.UI.TEXT_LIGHT },
								shadow = true,
								float = true,
								scale = 1.2 * 0.7,
								y_offset = -4,
							}),
							id = "blueatro_HUD_timer",
						},
					},
				},
			},
		},
	}
	return ret
end

local _new_round = new_round
function new_round()
	_new_round()
	G.GAME.blueatro_cost = 0
	BlueAtro.update_blind_timer()
end

-- ========================= CUSTOM UI FOR STUDENT CARDS =========================
local _desc_from_rows = desc_from_rows
function desc_from_rows(desc_nodes, empty, maxw)
	if desc_nodes[1] and desc_nodes[1][1] and desc_nodes[1][1].blueatro_ui_override then
		local t = {}
		for k, v in ipairs(desc_nodes) do
			t[#t + 1] = { n = G.UIT.R, config = { align = "cm", maxw = maxw }, nodes = v }
		end
		return {
			n = G.UIT.R,
			config = {
				align = "cm",
				colour = G.C.CLEAR,
				filler = true,
			},
			nodes = {
				{ n = G.UIT.R, config = { align = "cm", padding = 0.03 }, nodes = t },
			},
		}
	else
		return _desc_from_rows(desc_nodes, empty, maxw)
	end
end

---Builds a UI node to display the description of a skill.
---Skill is assumed to be an EX skill if `cost` is present, passive otherwise.
---@param key any Student's key
---@param vars table? Vars returned from `loc_vars`
---@param cost number? If not nil, cost of EX skill.
---@return table
function BlueAtro.build_skill_box(key, vars, cost)
	local set = cost and "BlueAtro_EX" or "BlueAtro_Passive"

	local desc_nodes = {}
	localize({ type = "descriptions", key = key, set = set, nodes = desc_nodes, vars = vars or {} })

	local desc = {}
	for _, v in ipairs(desc_nodes) do
		desc[#desc + 1] = { n = G.UIT.R, config = { align = "cm" }, nodes = v }
	end

	local name = localize({ type = "name_text", key = key, set = set, name_nodes = {}, vars = {} })
	if cost then
		name = string.format("%s (%d)", name, cost)
	end
	local name_node = {
		{
			n = G.UIT.O,
			config = {
				object = DynaText({
					string = { name },
					colours = { G.C.UI.TEXT_LIGHT },
					maxw = 5,
					y_offset = -0.6,
					scale = 0.35,
				}),
			},
		},
	}

	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			colour = lighten(G.C.BLACK, 0.05),
			r = 0.1,
			padding = 0.05,
			emboss = 0.05,
			outline = 1.0,
			outline_colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.05, r = 0.1 },
				nodes = name_node,
			},
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					r = 0.1,
					padding = 0.05,
					minw = 4,
					maxw = 4,
					colour = desc_nodes.background_colour or G.C.WHITE,
				},
				nodes = { { n = G.UIT.R, config = { align = "cm", padding = 0.03 }, nodes = desc } },
			},
		},
		blueatro_ui_override = true,
	}
end

--- `generate_ui` implementation for student cards.
BlueAtro.generate_student_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	local loc_vars = {}
	if self.loc_vars and type(self.loc_vars) == "function" then
		loc_vars = self:loc_vars(info_queue, card) or {}
	end

	if desc_nodes == full_UI_table.main and not full_UI_table.name then
		full_UI_table.name = localize({
			type = "name",
			set = self.set,
			key = self.key,
			nodes = full_UI_table.name,
		})
		desc_nodes[#desc_nodes + 1] = {
			BlueAtro.build_skill_box(self.blueatro_passive_key, loc_vars.blueatro_passive_vars),
			BlueAtro.build_skill_box(self.blueatro_ex_key, loc_vars.blueatro_ex_vars, self.blueatro_ex_cost),
		}
	end
end

-- Hook to add use button for Student cards.
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
						func = "blueatro_ex_can_use",
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

-- ========================= STUDENT CARDS EX SKILL USAGE =========================

---Checks whether a student can use its EX skill.
G.FUNCS.blueatro_ex_can_use = function(e)
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
		and card.config.center.blueatro_ex_cost <= G.GAME.blueatro_cost
		and card.config.center:blueatro_ex_can_use(card)

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
	BlueAtro.update_cost(-card.config.center.blueatro_ex_cost)
	card.config.center:blueatro_ex_use(card)
	card.area:remove_from_highlighted(card)

	-- Save gamestate
	G.FILE_HANDLER.force = true
end

-- ========================= MISC HOOKS  =========================

-- After playing a hand, cards marked with `card.blueatro.return_to_hand` are returned to hand instead
G.FUNCS.draw_from_play_to_discard = function(_)
	local play_count = #G.play.cards
	local i = 1
	for _, card in ipairs(G.play.cards) do
		if (not card.shattered) and not card.destroyed then
			if card.blueatro and card.blueatro.return_to_hand then
				card.blueatro.return_to_hand = nil
				draw_card(G.play, G.hand, i * 100 / play_count, "up", true, card)
			else
				draw_card(G.play, G.discard, i * 100 / play_count, "down", false, card)
			end
			i = i + 1
		end
	end
end

-- Create custom context for Joker destruction
local _card_remove = Card.remove
function Card.remove(self)
	---@diagnostic disable-next-line: undefined-field
	if self.added_to_deck and self.ability.set == "Joker" and not G.CONTROLLER.locks.selling_card then
		SMODS.calculate_context({
			blueatro = { destroying_joker = true, destroyed_joker = self },
		})
	end

	return _card_remove(self)
end

-- ========================= LOAD STUDENTS =========================
SMODS.Atlas({
	key = "students_atlas",
	path = "students.png",
	px = 71,
	py = 95,
})
local students = {
	-- Commons
	-- Uncommons
	-- Rares
	"000_neru",
}
for _, name in ipairs(students) do
	local file_path = "src/students/" .. name .. ".lua"
	assert(SMODS.load_file(file_path))()
end

-- ========================= LOAD ENHANCEMENTS =========================

assert(SMODS.load_file("src/enhancements.lua"))()
