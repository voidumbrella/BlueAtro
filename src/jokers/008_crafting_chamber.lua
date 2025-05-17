SMODS.Joker({
	key = "crafting_chamber",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(8),
	config = { extra = { cards_sold = 0, cards_needed = 3 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return {
			vars = { card.ability.extra.cards_needed, card.ability.extra.cards_needed - card.ability.extra.cards_sold },
		}
	end,
	calculate = function(_, card, context)
		if context.selling_card and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.cards_sold = card.ability.extra.cards_sold + 1
			if card.ability.extra.cards_sold >= card.ability.extra.cards_needed then
				card.ability.extra.cards_sold = 0
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.add_card({
							set = "Tarot",
							area = G.consumeables,
							key_append = "craft_chamber",
						})
						return true
					end,
				}))
				return {
					message = localize("k_plus_tarot"),
					colour = G.C.TAROT,
					card = card,
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "progress" },
				{ text = ")" },
			},
			calc_function = function(card)
				card.joker_display_values.progress =
					string.format("%d/%d", card.ability.extra.cards_sold, card.ability.extra.cards_needed)
			end,
		}
	end,
})
