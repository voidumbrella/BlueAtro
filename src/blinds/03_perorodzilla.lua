SMODS.Sound({
	key = "music_perorodzilla",
	path = "music_perorodzilla.ogg",
	pitch = 1.0,
	volume = 0.25,
	sync = false,
	select_music_track = function()
		return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_blueatro_perorodzilla") and math.huge or false
	end,
})

SMODS.Sound({
	key = "e_perorolaser",
	path = "e_perorolaser.wav",
})

SMODS.Blind({
	key = "perorodzilla",
	dollars = 5,
	mult = 2,
	boss_colour = HEX("537DDF"),
	atlas = "blueatro_blind_atlas",
	pos = { x = 0, y = 4 },
	boss = { min = 1, max = 10 },

	press_play = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.play.cards[1] then
					G.GAME.blind:wiggle()
					play_sound("blueatro_e_perorolaser")
					local card = G.play.cards[1]
					card:juice_up()
					SMODS.debuff_card(G.play.cards[1], true, "blueatro_perorodzilla")

					local childParts = Particles(0, 0, 0, 0, {
						timer_type = "TOTAL",
						timer = 0.01,
						scale = 0.25,
						lifespan = 2.5,
						attach = card,
						colours = { { 0.4, 1.0, 0.98, 1 } },
						fill = true,
					})
					G.E_MANAGER:add_event(Event({
						blockable = false,
						delay = 3.0,
						func = function()
							childParts:fade(3.0)
							return true
						end,
					}))
				end
				return true
			end,
		}))
	end,
})
