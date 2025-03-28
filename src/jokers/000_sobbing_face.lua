SMODS.Joker({
	key = "sobface",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(0),
	config = { extra = { mult = 3 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(_, card, context)
		if context.individual and context.cardarea == G.play and not context.other_card:is_face() then
			return {
				message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
				card = card or context.blueprint_card,
				mult = card.ability.extra.mult,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+" },
				{ ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
			},
			text_config = { colour = G.C.MULT },
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
				{ text = ")" },
			},
			calc_function = function(card)
				local mult = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= "Unknown" then
					for _, scoring_card in pairs(scoring_hand) do
						if not scoring_card:is_face() then
							mult = mult
								+ card.ability.extra.mult
									* JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.mult = mult
				card.joker_display_values.localized_text = localize("k_numbered_cards")
			end,
		}
	end,
})
