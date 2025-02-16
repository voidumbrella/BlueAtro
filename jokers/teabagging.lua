SMODS.Joker({
	key = "teabagging",
	atlas = "jokers_atlas",
	pos = { x = 1, y = 0 },
	config = { extra = { mult = 0, mult_gain = 4 } },
	rarity = 2,
	cost = 4,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
			}
		elseif context.remove_playing_cards and not context.blueprint then
			if not context.removed or #context.removed == 0 then
				return
			end
			for i = 1, #context.removed do
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				SMODS.calculate_effect({
					message = localize({
						type = "variable",
						key = "a_mult",
						vars = { card.ability.extra.mult },
					}),
					card = card,
				})
			end
		elseif context.jokers_destroyed and not context.blueprint then
			for i, joker in ipairs(context.destroyed) do
				-- This should not upgrade itself as it dies...
				if joker == card then
					return
				end
			end
			for i = 1, #context.destroyed do
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				SMODS.calculate_effect({
					message = localize({
						type = "variable",
						key = "a_mult",
						vars = { card.ability.extra.mult },
					}),
					card = card,
				})
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
			},
		}
	end,
})
