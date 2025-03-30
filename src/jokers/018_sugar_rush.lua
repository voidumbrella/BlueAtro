SMODS.Joker({
	key = "sugar_rush",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(18),
	config = { extra = { xmult = 3, xmult_loss = 0.25 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_loss } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
				card = card,
				colour = G.C.Mult,
			}
		elseif
			context.end_of_round
			and context.main_eval
			and G.GAME.blind.boss
			and not context.blueprint
			and not context.retrigger_joker
		then
			card.ability.extra.xmult = self.config.extra.xmult
			return {
				message = localize("k_sugar_replenished"),
				colour = G.C.FILTER,
			}
		elseif context.after then
			if card.ability.extra.xmult - card.ability.extra.xmult_loss >= 1.0 then
				card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_loss
				return {
					message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
					card = card,
				}
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
