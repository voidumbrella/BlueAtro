SMODS.Sound({
	key = "e_rip",
	path = "e_rip.wav",
})

SMODS.Joker({
	key = "torn_poster",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(24),
	config = {},
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	calculate = function(_, card, context)
		-- Implementing it here doesn't work because
		-- Jokers that have getting_sliced set to true
		-- are ignored during calculation steps.
	end,
})

local _card_remove = Card.remove
function Card:remove()
	if
		self.added_to_deck
		and not G.CONTROLLER.locks.selling_card
		and self.config.center_key == "j_blueatro_torn_poster"
	then
		play_sound("blueatro_e_rip", 1.0, 1.0)
		G.E_MANAGER:add_event(Event({
			func = function()
				if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
					SMODS.add_card({
						set = "Joker",
						key_append = "abydos_poster",
						rarity = 1,
					})
				end
				return true
			end,
		}))
	end
	return _card_remove(self)
end
