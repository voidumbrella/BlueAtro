SMODS.Joker({
	key = "chicken_skewer",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(14),
	config = { extra = { xmult = 3, xmult_loss = 0.05 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_loss } }
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
				colour = G.C.MULT,
				card = context.blueprint_card or card,
			}
		else
			if context.card_added and context.card.ability.set == "Joker" and not context.blueprint then
				card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_loss

				if card.ability.extra.xmult <= 1 then
					BlueAtro.pop_card(card)
					return {
						message = localize("k_eaten_ex"),
						colour = G.C.FILTER,
					}
				else
					return {
						message = localize({
							type = "variable",
							key = "a_xmult_minus",
							vars = { card.ability.extra.xmult_loss },
						}),
						colour = G.C.RED,
					}
				end
			end
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
