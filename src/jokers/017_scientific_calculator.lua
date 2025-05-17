SMODS.Joker({
	key = "calculator",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(17),
	config = { extra = { chips = 100 } },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_blueatro_pyroxene
		return { vars = { card.ability.extra.chips } }
	end,
	in_pools = function(self, args)
		for _, card in ipairs(G.playing_cards) do
			if SMODS.has_enhancement(card, "m_blueatro_pyroxene") then
				return true
			end
		end
		return false
	end,
	calculate = function(_, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			if SMODS.has_enhancement(context.other_card, "m_blueatro_pyroxene") then
				if context.other_card.debuff then
					return {
						message = localize("k_debuffed"),
						colour = G.C.RED,
						card = context.other_card,
					}
				else
					return {
						h_chips = card.ability.extra.chips,
					}
				end
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.CHIPS },
				{ ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
			},
			calc_function = function(card)
				local chips = 0
				for _, playing_card in ipairs(G.hand.cards) do
					if
						not playing_card.highlighted
						and SMODS.has_enhancement(playing_card, "m_blueatro_pyroxene")
						and not (playing_card.facing == "back")
						and not playing_card.debuff
					then
						chips = chips
							+ card.ability.extra.chips
								* JokerDisplay.calculate_card_triggers(playing_card, G.hand.highlighted)
					end
				end
				card.joker_display_values.chips = chips
			end,
		}
	end,
})
