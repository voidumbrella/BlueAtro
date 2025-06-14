SMODS.Joker({
	key = "bunny_grenade",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(34),
	config = { extra = { xmult = 1, xmult_gain = 0.75 } },
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.xmult >= 1 then
			return {
				x_mult = card.ability.extra.xmult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
		elseif context.first_hand_drawn and not context.blueprint and context.main_eval then
			local count = BlueAtro.count_filtered(G.hand.cards, function(c)
				return c.get_id == 7
			end)
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * count
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
				card = card,
			}
		elseif context.end_of_round and context.main_eval and not context.blueprint then
			card.ability.extra.xmult = self.config.extra.xmult
			return {
				message = localize("k_reset"),
				colour = G.C.MULT,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "X", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.MULT },
			},
		}
	end,
})
