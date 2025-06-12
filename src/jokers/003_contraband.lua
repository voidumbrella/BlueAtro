local should_proc = function(scoring_hand)
	if #scoring_hand == 0 then
		return false
	end

	local scored_6 = false
	local scored_9 = false
	local scored = {}
	for i = 1, #scoring_hand do
		if not scoring_hand[i].debuff and scoring_hand[i]:get_id() == 6 then
			scored_6 = true
		end
		if not scoring_hand[i].debuff and scoring_hand[i]:get_id() == 9 then
			scored_9 = true
		end
	end
	return scored_6 and scored_9
end

SMODS.Joker({
	key = "contraband",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(3),
	config = {},
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_death
	end,
	calculate = function(_, card, context)
		if context.first_hand_drawn and not context.blueprint and context.main_eval then
			juice_card_until(card, function()
				return G.GAME.current_round.hands_played == 0
			end, true)
		elseif context.after and context.cardarea == G.jokers then
			if
				G.GAME.current_round.hands_played == 0
				and should_proc(context.scoring_hand)
				and (#G.consumeables.cards + (G.GAME.consumeable_buffer or 0)) < G.consumeables.config.card_limit
			then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.0,
					func = function()
						SMODS.add_card({ set = "Tarot", key = "c_death" })
						G.GAME.consumeable_buffer = 0
						return true
					end,
				}))
				return {
					message = localize("k_shikei"),
					colour = G.C.SECONDARY_SET.Tarot,
					card = context.blueprint_card or card,
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.SECONDARY_SET.Tarot },
				{
					ref_table = "card.joker_display_values",
					ref_value = "count",
					retrigger_type = "mult",
					colour = G.C.SECONDARY_SET.Tarot,
				},
			},
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "active_msg" },
				{ text = ")" },
			},
			calc_function = function(card)
				local _, _, scoring_hand = JokerDisplay.evaluate_hand()
				local active = G.GAME and G.GAME.current_round.hands_played == 0
				card.joker_display_values.active = active
				card.joker_display_values.active_msg = (active and localize("jdis_active") or localize("jdis_inactive"))
				card.joker_display_values.count = (active and should_proc(scoring_hand)) and 1 or 0
			end,
			style_function = function(card, text, reminder_text, extra)
				if text and text.children[1] and text.children[2] then
					text.children[1].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Tarot
						or G.C.UI.TEXT_INACTIVE
					text.children[1].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Tarot
						or G.C.UI.TEXT_INACTIVE
				end
			end,
		}
	end,
})
