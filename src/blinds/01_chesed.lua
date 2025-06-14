SMODS.Sound({
	key = "music_chesed",
	path = "music_chesed.ogg",
	pitch = 1.0,
	volume = 0.25,
	sync = false,
	select_music_track = function()
		return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_blueatro_chesed") and math.huge or false
	end,
})

SMODS.Blind({
	key = "chesed",
	dollars = 5,
	mult = 2,
	boss_colour = HEX("DFC9C9"),
	atlas = "blueatro_blind_atlas",
	pos = { x = 0, y = 1 },
	boss = { min = 1, max = 10 },

	press_play = function(self)
		G.GAME.blind:wiggle()
		BlueAtro.ease_blind_chips(G.GAME.blind.chips * 1.20)
	end,
})
