SMODS.Joker({
	key = "iridescence",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(30),
	config = { extra = {} },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and context.cardarea == G.jokers
			and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
		then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					local c = SMODS.add_card({ set = "Spectral" })
					c.ability.eternal = true
					G.GAME.consumeable_buffer = 0
					SMODS.calculate_context({
						message = localize("k_plus_spectral"),
					})
					return true
				end,
			}))
		end
	end,
})
