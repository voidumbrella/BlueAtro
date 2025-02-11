--[[
--  Contraband
--]]
SMODS.Joker({
	key = "contraband",
	atlas = "jokers_atlas",
	pos = { x = 3, y = 0 },
	config = {},
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, center)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_death
	end,
	calculate = function(_, card, context)
		if context.after and context.cardarea == G.jokers then
			local scored_6 = false
			local scored_9 = false
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i]:get_id() == 6 then
					scored_6 = true
				end
				if context.scoring_hand[i]:get_id() == 9 then
					scored_9 = true
				end
			end
			if
				scored_6
				and scored_9
				and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
			then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.0,
					func = function()
						local _card = SMODS.create_card({ set = "Tarot", key = "c_death" })
						_card:add_to_deck()
						G.consumeables:emplace(_card)
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
})
