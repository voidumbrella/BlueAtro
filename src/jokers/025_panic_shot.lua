SMODS.Joker({
	key = "panic_shot",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(25),
	config = { extra = { xmult = 4, odds = 5 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.cardarea == G.jokers then
			if pseudorandom(pseudoseed("kayokoplzfear")) < G.GAME.probabilities.normal / card.ability.extra.odds then
				return {
					x_mult = card.ability.extra.xmult,
					card = context.blueprint_card or card,
					colour = G.C.MULT,
				}
			end
		elseif
			context.selling_card
			and context.card.ability.set == "Joker"
			and card.ability.extra.odds > 1
			and not context.blueprint
		then
			card.ability.extra.odds = card.ability.extra.odds - 1
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.GREEN,
			}
		elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			card.ability.extra.odds = self.config.extra.odds
			return {
				message = localize("k_reset"),
				colour = G.C.GREEN,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "X", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.MULT },
			},
			extra = {
				{
					{ text = "(" },
					{ ref_table = "card.joker_display_values", ref_value = "odds" },
					{ text = ")" },
				},
			},
			extra_config = { colour = G.C.GREEN, scale = 0.3 },
			calc_function = function(card)
				card.joker_display_values.odds = localize({
					type = "variable",
					key = "jdis_odds",
					vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds },
				})
			end,
		}
	end,
})
