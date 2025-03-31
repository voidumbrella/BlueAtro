SMODS.Sound({
	key = "e_rip",
	path = "e_rip.wav",
})

SMODS.Joker({
	key = "torn_poster",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(24),
	config = {},
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	calculate = function(_, card, context)
		if context.blueatro_destroying_joker and context.blueatro_destroyed_joker == card then
			-- Subtract 1 because this card is supposed to be destroyed
			-- but it needs to take up space while calculating.
			if #G.jokers.cards + G.GAME.joker_buffer - 1 < G.jokers.config.card_limit then
				SMODS.add_card({
					set = "Joker",
					key_append = "abydos_poster",
					rarity = 1,
				})
				play_sound("blueatro_e_rip", 1.0, 1.0)
			end
		end
	end,
})
