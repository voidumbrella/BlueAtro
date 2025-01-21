SMODS.Joker({
	key = "signed_photocard",
	atlas = "jokers_atlas",
	pos = { x = 5, y = 1 },
	config = { extra = { mult_gain = 2 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult_gain } }
	end,
	calculate = function(_, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 12 then
				context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0)
					+ card.ability.extra.mult_gain
				return {
					message = localize("k_upgrade_ex"),
					colour = G.C.MULT,
					card = card,
				}
			end
		end
	end,
})
