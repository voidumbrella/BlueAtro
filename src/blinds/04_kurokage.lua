SMODS.Sound({
	key = "music_kurokage",
	path = "music_kurokage.ogg",
	pitch = 1.0,
	volume = 0.25,
	sync = false,
	select_music_track = function()
		return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_blueatro_kurokage") and math.huge or false
	end,
})

SMODS.Blind({
	key = "kurokage",
	dollars = 5,
	mult = 2,
	boss_colour = HEX("537DDF"),
	atlas = "blueatro_blind_atlas",
	pos = { x = 0, y = 5 },
	boss = { min = 1, max = 10 },

	press_play = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, card in ipairs(G.playing_cards) do
					if card:get_id() == card:get_id() then
						G.GAME.blind:wiggle()
						SMODS.debuff_card(card, true, "blueatro_kurokage")
					end
				end
				return true
			end,
		}))
	end,

	defeat = function(self)
		for _, card in ipairs(G.playing_cards) do
			SMODS.debuff_card(card, false, "blueatro_kurokage")
		end
	end,

	disable = function(self)
		for _, card in ipairs(G.playing_cards) do
			SMODS.debuff_card(card, false, "blueatro_kurokage")
		end
	end,

	drawn_to_hand = function(self)
		for _, card in ipairs(G.playing_cards) do
			SMODS.debuff_card(card, false, "blueatro_kurokage")
		end
	end,
})
