SMODS.Joker({
	key = "elixir_of_youth",
	atlas = "jokers_atlas",
	pos = { x = 5, y = 0 },
	config = {},
	rarity = 3,
	cost = 6,
	blueprint_compat = false,
	loc_vars = function(_, info_queue, card) end,
	calculate = function(_, card, context)
		if context.first_hand_drawn and not context.blueprint and not card.retrigger_joker then
			juice_card_until(card, function()
				return G.GAME.current_round.hands_played == 0
			end, true)
		elseif context.destroying_card and not context.blueprint and not context.retrigger_joker then
			if
				G.GAME.current_round.hands_played == 0
				and #context.full_hand == 1
				and context.full_hand[1]:is_face()
			then
				-- Create the random 9
				local random_suit = pseudorandom_element({ "C", "S", "D", "H" }, pseudoseed("elixir_of_youth_suit"))
				local enhancement_pool = {}
				for _, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
					if v.key ~= "m_stone" then
						enhancement_pool[#enhancement_pool + 1] = v
					end
				end
				local enhancement = pseudorandom_element(enhancement_pool, pseudoseed("elixir_of_youth_enhancement"))

				playing_card_joker_effects({ true })
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					func = function()
						create_playing_card({
							front = G.P_CARDS[random_suit .. "_9"],
							center = enhancement,
						}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
						return true
					end,
				}))

				return true
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+" },
				{ ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
			},
			calc_function = function(card)
				local _, _, scoring_hand = JokerDisplay.evaluate_hand()
				local should_proc = #scoring_hand == 1 and scoring_hand[1]:is_face()
				local active = G.GAME and G.GAME.current_round.hands_played == 0
				card.joker_display_values.active = active
				card.joker_display_values.count = (active and should_proc) and 1 or 0
			end,
			style_function = function(card, text, reminder_text, extra)
				if text and text.children[1] and text.children[2] then
					text.children[1].config.colour = card.joker_display_values.active and G.C.WHITE
						or G.C.UI.TEXT_INACTIVE
					text.children[2].config.colour = card.joker_display_values.active and G.C.WHITE
						or G.C.UI.TEXT_INACTIVE
				end
			end,
		}
	end,
})
