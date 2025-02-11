--[[
--  Elixir of Youth
--]]
SMODS.Joker({
	key = "elixir_of_youth",
	atlas = "jokers_atlas",
	pos = { x = 5, y = 0 },
	config = {},
	rarity = 3,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, center) end,
	calculate = function(_, card, context)
		if context.first_hand_drawn and not context.blueprint then
			juice_card_until(card, function()
				return G.GAME.current_round.hands_played == 0
			end, true)
		elseif context.destroying_card and not context.blueprint then
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
})
