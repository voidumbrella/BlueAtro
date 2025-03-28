SMODS.Joker({
	key = "cheerleader",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(12),
	config = { extra = {} },
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card) end,
	calculate = function(_, card, context)
		if context.repetition and context.cardarea == G.play and not context.other_card.debuff then
			if context.other_card.ability.effect == "Stone Card" then
				-- Rankless!
				return
			end
			local num_retriggers = 0
			local rank = context.other_card:get_id()
			for i = 1, #G.hand.cards do
				local card_in_hand = G.hand.cards[i]
				if card_in_hand:get_id() == rank and not card_in_hand.debuff then
					num_retriggers = num_retriggers + 1
				end
			end
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
