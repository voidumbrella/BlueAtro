--[[
--  Sobbing Face
--]]
local should_proc = function(scoring_hand)
	if #scoring_hand == 0 then
		return false
	end

	for i = 1, #scoring_hand do
		local id = scoring_hand[i]:get_id()
		-- Aces count as ones
		if id > 7 and id ~= 14 then
			return false
		end
	end
	return true
end

SMODS.Joker({
	key = "sobface",
	atlas = "jokers_atlas",
	pos = { x = 0, y = 0 },
	config = { extra = { dollar_gain = 1 } },
	rarity = 1,
	cost = 2,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.dollar_gain } }
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			if should_proc then
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
				{ text = "(< 7)", scale = 0.35 },
			},
			calc_function = function(card)
				local _, _, scoring_hand = JokerDisplay.evaluate_hand()
				card.joker_display_values.dollars = should_proc(scoring_hand) and card.ability.extra.dollar_gain or 0
			end,
		}
	end,
})
