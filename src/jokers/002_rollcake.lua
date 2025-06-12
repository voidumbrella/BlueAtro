SMODS.Joker({
	key = "rollcake",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(2),
	config = { extra = { rounds = 5, rounds_left = 5, odds = 2 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.rounds_left, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	calculate = function(_, card, context)
		if context.hand_drawn and not context.blueprint then
			if G.GAME.current_round.hands_played == 0 then
				local eval = function()
					return G.GAME.current_round.hands_played == 0
				end
				juice_card_until(card, eval, true)
			end
		end

		if context.after and context.cardarea == G.jokers then
			if
				G.GAME.current_round.hands_played == 0
				and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
				and pseudorandom(pseudoseed("rollcake")) < G.GAME.probabilities.normal / card.ability.extra.odds
			then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						for _, v in pairs(G.P_CENTER_POOLS.Planet) do
							if v.config.hand_type == context.scoring_name then
								SMODS.add_card({ set = "Planet", key = v.key })
								break
							end
						end
						G.GAME.consumeable_buffer = 0
						card_eval_status_text(
							context.blueprint_card or card,
							"extra",
							nil,
							nil,
							nil,
							{ message = localize("k_plus_planet") }
						)
						return true
					end,
				}))
			end
		end

		if context.end_of_round and context.main_eval and not context.blueprint then
			if card.ability.extra.rounds_left - 1 <= 0 then
				BlueAtro.pop_card(card)
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
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "(" },
				{ ref_table = "card.ability.extra", ref_value = "rounds_left" },
				{ text = "/" },
				{ ref_table = "card.ability.extra", ref_value = "rounds" },
				{ text = ")" },
			},
			text_config = { colour = lighten(G.C.GREY, 0.8), scale = 0.2 },
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "active" },
				{ text = ")" },
			},
			extra = {
				{
					{ text = "(" },
					{ ref_table = "card.joker_display_values", ref_value = "odds" },
					{ text = ")" },
				},
			},
			extra_config = { colour = G.C.GREEN, scale = 0.3 },
			calc_function = function(card)
				card.joker_display_values.active = (
					G.GAME and G.GAME.current_round.hands_played == 0 and localize("jdis_active")
					or localize("jdis_inactive")
				)
				card.joker_display_values.odds = localize({
					type = "variable",
					key = "jdis_odds",
					vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds },
				})
			end,
		}
	end,
})
