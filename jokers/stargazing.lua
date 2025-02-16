SMODS.Joker({
	key = "stargazing",
	atlas = "jokers_atlas",
	pos = { x = 0, y = 1 },
	config = { extra = {} },
	rarity = 1,
	cost = 3,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card) end,
	calculate = function(_, card, context)
		if context.using_consumeable then
			if context.consumeable.ability.set == "Tarot" then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						local planet_card = SMODS.create_card({ set = "Planet" })
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
						return true
					end,
				}))
			end
		end
	end,
})
