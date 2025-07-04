SMODS.Joker({
	key = "nemugaki",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(9),
	config = { extra = { mult = 0, mult_gain = 3, rerolled = false } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_gain,
				card.ability.extra.mult,
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
		elseif context.ending_shop and not context.blueprint and context.main_eval and not card.ability.rerolled then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			card.ability.rerolled = false
			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
				card = card,
			}
		elseif context.reroll_shop then
			card.ability.rerolled = true
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
			},
		}
	end,
})
