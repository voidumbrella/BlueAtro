SMODS.Sound({
	key = "music_goz",
	path = "music_goz.ogg",
	pitch = 1.0,
	volume = 0.25,
	sync = false,
	select_music_track = function()
		return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_blueatro_goz") and math.huge or false
	end,
})

local function goz_scramble_hand()
	G.GAME.blind:wiggle()
	for _, card in ipairs(G.hand.cards) do
		card:flip()
	end
	G.E_MANAGER:add_event(Event({
		func = function()
			G.hand:shuffle("blueatro_goz")
			return true
		end,
	}))
end

SMODS.Blind({
	key = "goz",
	dollars = 5,
	mult = 2,
	boss_colour = HEX("537DDF"),
	atlas = "blueatro_blind_atlas",
	pos = { x = 0, y = 2 },
	boss = { min = 1, max = 10 },

	press_play = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				goz_scramble_hand()
				return true
			end,
		}))
	end,
})

local G_FUNCS_discard_cards_from_highlighted = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
	G_FUNCS_discard_cards_from_highlighted(e, hook)
	if G.GAME.blind.name == "bl_blueatro_goz" then
		G.E_MANAGER:add_event(Event({
			func = function()
				goz_scramble_hand()
				return true
			end,
		}))
	end
end
