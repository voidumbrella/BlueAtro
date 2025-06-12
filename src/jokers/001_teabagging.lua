SMODS.Joker({
	key = "teabagging",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(1),
	config = { extra = { mult = 0, mult_gain = 4 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult = card.ability.extra.mult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
		elseif context.remove_playing_cards and not context.blueprint and context.main_eval then
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
				}, card)
			end
		elseif context.blueatro_destroying_joker and not context.blueprint then
			if card == context.blueatro_destroyed_joker then
				return
			end
			local new_mult = card.ability.extra.mult + card.ability.extra.mult_gain
			card.ability.extra.mult = new_mult
			-- Wrap it in an event so when multiple Jokers are destroyed a dead copy of this doesn't proc effects
			G.E_MANAGER:add_event(Event({
				func = function()
					if card.removed then
						return true
					end
					SMODS.calculate_effect({
						message = localize({
							type = "variable",
							key = "a_mult",
							vars = { new_mult },
						}),
					}, card)
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
