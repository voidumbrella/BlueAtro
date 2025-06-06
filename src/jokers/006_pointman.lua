local calculate_xmult = function(card)
	if not G.jokers or not G.jokers.cards then
		return 1.0
	end

	local joker_count = 0
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then
			joker_count = #G.jokers.cards - i
		end
	end
	return 1.0 + (card.ability.extra.xmult_per_joker * joker_count)
end

SMODS.Joker({
	key = "pointman",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(6),
	config = { extra = { xmult_per_joker = 0.5 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_per_joker,
				calculate_xmult(card),
			},
		}
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			local xmult = calculate_xmult(card)
			return {
				x_mult = xmult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "X", colour = G.C.MULT },
				{ ref_table = "card.joker_display_values", ref_value = "xmult", colour = G.C.MULT },
			},
			calc_function = function(card)
				card.joker_display_values.xmult = calculate_xmult(card)
			end,
		}
	end,
})
