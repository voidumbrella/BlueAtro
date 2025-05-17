SMODS.Joker({
	key = "hero",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(4),
	config = { extra = { mult = 0, mult_gain = 1, cards_needed = 4, cards_scored = 0 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_gain,
				card.ability.extra.cards_needed,
				card.ability.extra.mult,
				card.ability.extra.cards_needed - card.ability.extra.cards_scored,
			},
		}
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult = card.ability.extra.mult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
		elseif
			context.individual
			and context.cardarea == G.play
			and not context.blueprint
			and not context.retrigger_joker
			and not context.other_card.debuff
		then
			card.ability.extra.cards_scored = card.ability.extra.cards_scored + 1
			if card.ability.extra.cards_scored >= card.ability.extra.cards_needed then
				card.ability.extra.cards_scored = 0
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
					message = localize("k_levelup"),
					colour = G.C.MULT,
					card = card,
					sound = "timpani",
				}
			else
				return {
					message = string.format("%d/%d", card.ability.extra.cards_scored, card.ability.extra.cards_needed),
					card = card,
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
			},
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "progress" },
				{ text = ")" },
			},
			calc_function = function(card)
				card.joker_display_values.progress =
					string.format("%d/%d", card.ability.extra.cards_scored, card.ability.extra.cards_needed)
			end,
		}
	end,
})
