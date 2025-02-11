--[[
--  Pointman
--]]
SMODS.Joker({
	key = "pointman",
	atlas = "jokers_atlas",
	pos = { x = 6, y = 0 },
	config = { extra = { Xmult_per_joker = 0.5 } },
	rarity = 2,
	cost = 5,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		local xmult = 1.0
		if G.jokers then
			local joker_count = 0
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					joker_count = #G.jokers.cards - i
				end
			end
			xmult = 1.0 + (card.ability.extra.Xmult_per_joker * joker_count)
		end
		return {
			vars = {
				card.ability.extra.Xmult_per_joker,
				xmult,
			},
		}
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			local joker_count = 0
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					joker_count = #G.jokers.cards - i
				end
			end
			local xmult = 1.0 + (card.ability.extra.Xmult_per_joker * joker_count)
			return {
				Xmult_mod = xmult,
				message = localize({ type = "variable", key = "a_xmult", vars = { xmult } }),
			}
		end
	end,
})
