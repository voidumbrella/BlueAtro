SMODS.Joker({
	key = "signed_photocard",
	atlas = "jokers_atlas",
	pos = { x = 5, y = 1 },
	config = { extra = { chip_gain = 3, chips = 0 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.chips > 0 then
			return {
				chips_mod = card.ability.extra.chips,
				message = localize({ type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }),
			}
		elseif
			context.individual
			and context.cardarea == G.play
			and not context.blueprint
			and not context.retrigger_joker
		then
			if context.other_card:is_face() then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
				return {
					message = localize("k_upgrade_ex"),
					card = card,
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.CHIPS },
				{ ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
			},
		}
	end,
})
