BlueAtro = {}
-- Used for students because I'm lazy
BlueAtro.id_to_atlas_pos = function(id)
	return { x = id % 10, y = math.floor(id / 10) }
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

	self.GAME.blueatro_cost = self.GAME.blueatro_cost or {
		val = 0,
		str = "0",
		max = 10,
		per_sec = 0.5,
	}

	-- UI for displaying current Cost.
	self.blueatro_costbar = UIBox({
		definition = BlueAtro.create_UIBox_cost(),
		config = { align = "cr", offset = { x = -1, y = 0 }, major = G.ROOM_ATTACH, bond = "Weak" },
	})
	self.blueatro_costbar.states.visible = true
end

-- Run whenever starting a new round
local _new_round = new_round
function new_round()
	_new_round()
	-- TODO: This might be better if it was at the end of round?
	G.GAME.blueatro_cost.val = 0
end

local _Game_delete_run = Game.delete_run
function Game:delete_run(args)
	_Game_delete_run(self, args)
	-- Delete UI elements.
	if self.ROOM then
		if self.blueatro_costbar then
			self.blueatro_costbar:remove()
			self.blueatro_costbar = nil
		end
	end
end

-- Initialize run-wide global variables
local _Game_init_game_object = Game.init_game_object
function Game:init_game_object()
	local ret = _Game_init_game_object(self)
	ret.blueatro = {}
	ret.blueatro.yuzu_combo = { "High Card", "Three of a Kind", "Two Pair" }
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
		local yuzu_combo = G.GAME.blueatro.yuzu_combo
		table.remove(yuzu_combo, 1)
		yuzu_combo[#yuzu_combo + 1] = next
		--END: Yuzu's Combo
	end
	-- END: Update round-global variables after each hand

	return ret
end

---Modify the current Cost by given amount.
---@param delta number Change to the cost meter.
function BlueAtro.update_cost(delta)
	local last = G.GAME.blueatro_cost.val
	local cur = last + delta
	-- Incremented
	if math.floor(last) < math.floor(cur) then
		play_sound("chips1")
	end
	G.GAME.blueatro_cost.val = math.max(0, math.min(cur, G.GAME.blueatro_cost.max))

	G.GAME.blueatro_cost.str = tostring(math.floor(cur))
	local cost_UI = G.blueatro_costbar:get_UIE_by_ID("blueatro_costbar_UI")
	cost_UI.config.object:update()
	G.blueatro_costbar:recalculate()
end

---UIBox definition for Cost meter.
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
								ref_table = G.GAME.blueatro_cost,
								ref_value = "str",
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

local _Game_update = G.update
function Game:update(dt)
	_Game_update(self, dt)

	-- Game is not paused, and player actually has control.
	if not G.SETTINGS.paused and self.STATE == self.STATES.SELECTING_HAND then
		BlueAtro.update_cost(G.GAME.blueatro_cost.per_sec * dt)
	end
end

-- ========================= CUSTOM UI FOR STUDENT CARDS =========================
local _desc_from_rows = desc_from_rows
function desc_from_rows(desc_nodes, empty, maxw)
	-- If flag is present, remove the white box in the descriptions because
	-- we provide our own tooltip boxes for students and it's ugly to have both.
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
---This is self contained and should be inserted directly into `nodes`.
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
		-- Override the default tooltip structure. See `desc_from_rows`.
		blueatro_ui_override = true,
	}
end

---`generate_ui` implementation for student cards.
---All students must manually specify this as their `generate_ui` function.
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
		-- Keys are stored as "j_blueatro_{key}"
		local base_key = self.key:match("_([^_]*)$")
		local passive_key = "blueatro_psv_" .. base_key
		local ex_key = "blueatro_ex_" .. base_key
		desc_nodes[#desc_nodes + 1] = {
			BlueAtro.build_skill_box(passive_key, loc_vars.blueatro_passive_vars),
			{ n = G.UIT.R, config = { minh = 0.13 }, nodes = {} },
			BlueAtro.build_skill_box(ex_key, loc_vars.blueatro_ex_vars, self.blueatro_ex_cost),
		}
	end
end

-- ========================= STUDENT CARDS EX SKILL USAGE =========================
-- Hook to add use button for Student cards.
-- Thank you github.com/Mysthaps/LobotomyCorp
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
								text = "EX",
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

---Checks whether a student can use its EX skill.
G.FUNCS.blueatro_ex_can_use = function(e)
	local card = e.config.ref_table

	local student_consents = card.area == G.jokers
		and not card.debuff
		and card.config.center.blueatro_ex_use
		and card.config.center.blueatro_ex_cost <= G.GAME.blueatro_cost.val
		and card.config.center:blueatro_ex_can_use(card)

	if G.STATE == G.STATES.SELECTING_HAND and student_consents then
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

	-- EX cost is always stored positive!
	BlueAtro.update_cost(-card.config.center.blueatro_ex_cost)
	card.config.center:blueatro_ex_use(card)

	-- Force save gamestate.
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
local students = {}

local path = SMODS.current_mod.path .. "/src/students"
local files = NFS.getDirectoryItemsInfo(path)
for i = 1, #files do
	local file = files[i]
	if file.name:sub(-4) == ".lua" then
		students[#students + 1] = file.name
	end
end
table.sort(students)

for _, filename in ipairs(students) do
	local file_path = "src/students/" .. filename
	assert(SMODS.load_file(file_path))()
end

-- ========================= LOAD ENHANCEMENTS =========================
assert(SMODS.load_file("src/enhancements.lua"))()
