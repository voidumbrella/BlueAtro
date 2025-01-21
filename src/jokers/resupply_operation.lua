SMODS.Joker({
	key = "resupply_operation",
	atlas = "jokers_atlas",
	pos = { x = 0, y = 2 },
	config = { extra = { inc = 1, applied_hand_size = 0, hand_size = 0 } },
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.inc, card.ability.extra.hand_size } }
	end,
	calculate = function(self, card, context)
		-- Fast out
		if context.blueprint then
			return
		end

		if
			context.after
			and context.main_eval
			and next(context.poker_hands["Full House"])
			and not context.retrigger_joker
		then
			card.ability.extra.hand_size = card.ability.extra.hand_size + card.ability.extra.inc
			juice_card_until(card, function()
				return card.ability.extra.hand_size > 0
			end, true)
			return {
				message = localize("a_handsize"),
				card = card,
			}
		elseif context.setting_blind then
			-- The hand size should apply before drawing the hand,
			-- ...
			G.hand:change_size(card.ability.extra.hand_size)
			card.ability.extra.applied_hand_size = card.ability.extra.hand_size
			return
		elseif context.first_hand_drawn and card.ability.extra.hand_size > 0 then
			-- ...
			-- but it looks nicer to reset after drawing the hand
			card.ability.extra.hand_size = 0
			return { message = localize("k_reset"), card = card }
		elseif context.end_of_round and context.main_eval then
			-- Undo handsize change to fully reset
			G.hand:change_size(-card.ability.extra.applied_hand_size)
			return
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+" },
				{ ref_table = "card.ability.extra", ref_value = "hand_size" },
			},
		}
	end,
})
