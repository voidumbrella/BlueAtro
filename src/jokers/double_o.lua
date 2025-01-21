SMODS.Joker({
	key = "double_o",
	atlas = "jokers_atlas",
	pos = { x = 6, y = 1 },
	config = { extra = { xmult = 1, xmult_gain = 0.5 } },
	rarity = 3,
	cost = 9,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.xmult >= 1 then
			return {
				Xmult_mod = card.ability.extra.xmult,
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
			}
		elseif
			context.individual
			and context.cardarea == G.play
			and not context.blueprint
			and not context.other_card.debuff
			and context.other_card:get_id() == 14
		then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
				card = card,
			}
		elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			card.ability.extra.xmult = 1
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
