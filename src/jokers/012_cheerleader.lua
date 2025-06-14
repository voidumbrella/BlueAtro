SMODS.Joker({
	key = "cheerleader",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(12),
	config = { extra = {} },
	rarity = 3,
	cost = 10,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card) end,
	calculate = function(_, card, context)
		if context.repetition and context.cardarea == G.play and not context.other_card.debuff then
			if context.other_card.ability.effect == "Stone Card" then
				-- Rankless!
				return
			end
			local rank = context.other_card:get_id()
			local num_retriggers = BlueAtro.count_filtered(G.hand.cards, function(c)
				return c:get_id() == rank
			end)
			if num_retriggers > 0 then
				return {
					message = localize("k_again_ex"),
					repetitions = num_retriggers,
					card = card,
				}
			end
		end
	end,
})
