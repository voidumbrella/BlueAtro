local should_proc = function(discount)
	if not G.GAME or not G.GAME.current_round or not G.GAME.current_round.blueatro then
		return false
	end
	return #discount == G.GAME.current_round.blueatro.bookkeeping_count
end

SMODS.Joker({
	key = "bookkeeping",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(13),
	config = { extra = { dollar_gain = 4 } },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.dollar_gain,
				G.GAME.current_round.blueatro.bookkeeping_count,
			},
		}
	end,
	calculate = function(_, card, context)
		if context.pre_discard then
			if should_proc(G.hand.highlighted) then
				ease_dollars(card.ability.extra.dollar_gain)
				return {
					message = localize("$") .. card.ability.extra.dollar_gain,
					colour = G.C.MONEY,
					card = card,
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+$", colour = G.C.MONEY },
				{ ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY },
			},
			reminder_text = {
				{ text = "(Discard ", scale = 0.25 },
				{ ref_table = "card.joker_display_values", ref_value = "count", scale = 0.25 },
				{ text = " cards)", scale = 0.25 },
			},
			calc_function = function(card)
				card.joker_display_values.count = G.GAME.current_round.blueatro.bookkeeping_count
				if not G.hand or not G.hand.highlighted then
					card.joker_display_values.dollars = 0
				else
					card.joker_display_values.dollars = should_proc(G.hand.highlighted)
							and card.ability.extra.dollar_gain
						or 0
				end
			end,
		}
	end,
})
