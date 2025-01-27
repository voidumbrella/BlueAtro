--[[
--  Roll Cake
--]]
SMODS.Joker({
	key = "rollcake",
	atlas = "jokers_atlas",
	pos = { x = 2, y = 0 },
	config = { extra = { rounds_left = 3 } },
	eternal_compat = false,
	rarity = 2,
	cost = 6,
	loc_vars = function(_, _, card)
		return { vars = { card.ability.extra.rounds_left, G.GAME.current_round.hands_played or 0 } }
	end,
	calculate = function(_, card, context)
		if context.hand_drawn and not context.blueprint then
			if G.GAME.current_round.hands_played == 2 then
				local eval = function()
					return G.GAME.current_round.hands_played == 2
				end
				juice_card_until(card, eval, true)
			end
		end

		if context.before and context.cardarea == G.jokers then
			if
				G.GAME.current_round.hands_played == 2
				and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
			then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				local planet_card
				for k, v in pairs(G.P_CENTER_POOLS.Planet) do
					if v.config.hand_type == context.scoring_name then
						planet_card = SMODS.create_card({ set = "Planet", key = v.key, key_append = "rollcake" })
					end
				end
				planet_card:add_to_deck()
				G.consumeables:emplace(planet_card)
				G.GAME.consumeable_buffer = 0
				card_eval_status_text(
					context.blueprint_card or card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_plus_planet") }
				)

				if not context.blueprint then
					if card.ability.extra.rounds_left - 1 <= 0 then
						G.E_MANAGER:add_event(Event({
							func = function()
								play_sound("tarot1")
								card.T.r = -0.2
								card:juice_up(0.3, 0.4)
								card.states.drag.is = true
								card.children.center.pinch.x = true
								G.E_MANAGER:add_event(Event({
									trigger = "after",
									delay = 0.3,
									blockable = false,
									func = function()
										G.jokers:remove_card(card)
										for i = 1, #G.jokers.cards do
											if G.jokers.cards[i] ~= card then
												effect = G.jokers.cards[i]:calculate_joker({
													joker_destroyed = true,
													destroyed = card,
												})
											end
										end
										card:remove()
										card = nil
										return true
									end,
								}))
								return true
							end,
						}))
						return {
							message = localize("k_eaten_ex"),
							colour = G.C.FILTER,
						}
					else
						card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
						return {
							message = card.ability.extra.rounds_left .. "",
							colour = G.C.FILTER,
						}
					end
				end
			end
		end
	end,
})
