SMODS.Joker({
	key = "quick_reload",
	atlas = "jokers_atlas",
	pos = { x = 9, y = 1 },
	config = {},
	rarity = 2,
	cost = 7,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if
			context.after
			and context.main_eval
			and next(context.poker_hands["Two Pair"])
			and not context.blueprint
			and not context.retrigger_joker
		then
			local i = 0
			for _, played_card in ipairs(G.play.cards) do
				-- TODO: Do I want to be this anal about this
				if (not played_card.shattered) and not played_card.destroyed then
					played_card.blueatro = { return_to_hand = true }
					i = i + 1
					if i >= 2 then
						return true
					end
				end
			end
		end
	end,
})
