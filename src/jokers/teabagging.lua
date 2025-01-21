SMODS.Joker({
	key = "teabagging",
	atlas = "jokers_atlas",
	pos = { x = 1, y = 0 },
	config = { extra = { mult = 0, mult_gain = 4, already_shown = false } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
			}
		elseif context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
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
		elseif context.blueatro and context.blueatro.destroying_joker and not context.blueprint then
			if card == context.blueatro.joker_destroyed then
				return
			end
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			-- Wrap it in an event so when multiple Jokers are destroyed a dead copy of this doesn't proc effects
			G.E_MANAGER:add_event(Event({
				func = function()
					if card.removed or card.already_shown then
						return true
					end
					-- If multiple Jokers are destroyed at once, only show the proc once
					card.alrady_shown = true
					SMODS.calculate_effect({
						message = localize({
							type = "variable",
							key = "a_mult",
							vars = { card.ability.extra.mult },
						}),
						card = card,
					})
					return true
				end,
			}))
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
