SMODS.Joker({
	key = "account_reroll",
	atlas = "jokers_atlas",
	pos = { x = 2, y = 2 },
	config = {},
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card) end,
	calculate = function(_, card, context)
		if context.reroll_shop and not context.blueprint and not context.retrigger_joker then
			local pos = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					pos = i + 1
					break
				end
			end
			if pos == nil then
				return
			end

			local next_joker = G.jokers.cards[pos]
			if next_joker and not next_joker.eternal then
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up(0.8)
						next_joker:remove()
						local c = SMODS.add_card({
							set = "Joker",
							rarity = 0.75,
							key_append = "risemara",
						})
						for i = #G.jokers.cards, pos + 1, -1 do
							G.jokers.cards[i] = G.jokers.cards[i - 1]
						end
						G.jokers.cards[pos] = c
						play_sound("generic1")
						return true
					end,
				}))
			end
		end
	end,
})
