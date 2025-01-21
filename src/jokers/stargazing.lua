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
			if
				context.consumeable.ability.set == "Tarot"
				and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
			then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				local _card = context.blueprint_card or card
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					func = function()
						SMODS.add_card({ set = "Planet" })
						G.GAME.consumeable_buffer = 0
						card_eval_status_text(_card, "extra", nil, nil, nil, { message = localize("k_plus_planet") })
						return true
					end,
				}))
			end
		end
	end,
})
