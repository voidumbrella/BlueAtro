SMODS.Joker({
	key = "photocard",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(15),
	config = { extra = { chip_gain = 25 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.chip_gain } }
	end,
	calculate = function(_, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 12 then
				context.other_card.ability.perma_chip = (context.other_card.ability.perma_chip or 0)
					+ card.ability.extra.chip_gain
				return {
					message = localize("k_upgrade_ex"),
					colour = G.C.CHIPS,
					card = context.blueprint_card or card,
				}
			end
		end
	end,
})
