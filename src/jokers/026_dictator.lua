SMODS.Joker({
	key = "dictator",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(26),
	config = { extra = { mult = 3 } },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.discard and #context.full_hand == 1 then
			SMODS.debuff_card(G.hand.highlighted[1], true, "blueatro_cherino")
			for i = 1, #G.hand.cards do
				local card_in_hand = G.hand.cards[i]
				if not card_in_hand.highlighted then
					card_in_hand.ability.perma_mult = (card_in_hand.ability.perma_mult or 0) + card.ability.extra.mult
					SMODS.calculate_effect({
						message = localize("k_upgrade_ex"),
						colour = G.C.MULT,
					}, card_in_hand)
				end
			end
			return {
				message = localize("k_purge"),
				colour = G.C.MULT,
				card = context.blueprint_card or card,
			}
		end
	end,
})
