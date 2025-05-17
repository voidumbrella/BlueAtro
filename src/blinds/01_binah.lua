SMODS.Sound({
	key = "music_binah",
	path = "music_binah.ogg",
	pitch = 1.0,
	volume = 0.25,
	sync = false,
	select_music_track = function()
		return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_blueatro_binah") and math.huge or false
	end,
})

SMODS.Blind({
	key = "binah",
	dollars = 5,
	mult = 16,
	boss_colour = HEX("A88571"),
	atlas = "blueatro_blind_atlas",
	pos = { x = 0, y = 0 },
	boss = { min = 1, max = 10 },

	set_blind = function(self)
		G.GAME.blind.hands = {}
		for k, v in pairs(G.GAME.hands) do
			G.GAME.blind.hands[k] = false
		end
	end,

	press_play = function(self)
		local poker_hand, _, _, _, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
		if G.GAME.blind.hands[poker_hand] == false then
			G.GAME.blind.hands[poker_hand] = true
			BlueAtro.ease_blind_chips(math.floor(G.GAME.blind.chips / 2))
		end
		G.GAME.blind:wiggle()
	end,

	defeat = function(self)
		G.GAME.blind_hands = nil
	end,

	disable = function(self)
		G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante) * 2 * G.GAME.starting_params.ante_scaling
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	end,
})
