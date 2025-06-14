SMODS.Joker({
	key = "account_reroll",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(22),
	config = {},
	rarity = 3,
	cost = 7,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(_, info_queue, card) end,
	calculate = function(_, card, context)
		if context.reroll_shop and not context.blueprint and not context.retrigger_joker then
			local pos = BlueAtro.get_card_pos(G.jokers, card)
			if pos == nil then
				return
			end

			local next_joker = G.jokers.cards[pos]
			if next_joker and not next_joker.eternal then
				next_joker.getting_sliced = true
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up(0.8)
						next_joker:remove()
						if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
							local c = SMODS.add_card({
								set = "Joker",
								key_append = "risemara",
							})
							for i = #G.jokers.cards, pos + 1, -1 do
								G.jokers.cards[i] = G.jokers.cards[i - 1]
							end
							G.jokers.cards[pos] = c
							play_sound("generic1")
							SMODS.calculate_effect({
								message = localize("k_rerolled"),
							}, card)
						else
							SMODS.calculate_effect({
								message = localize("k_no_room_ex"),
							}, card)
						end
						return true
					end,
				}))
			end
		end
	end,
})
