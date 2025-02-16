SMODS.Joker({
	key = "cheerleader",
	atlas = "jokers_atlas",
	pos = { x = 1, y = 2 },
	config = { extra = { } },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card) end,
	calculate = function(_, card, context)
		if context.repetition and context.cardarea == G.play then
            local num_retriggers = 0
            local rank = context.other_card:get_id()
            for i = 1, #G.hand.cards do
				if G.hand.cards[i]:get_id() == rank then
					num_retriggers = num_retriggers + 1
				end
			end

            if num_retriggers > 0 then
                return {
                    message = localize("k_again_ex"),
                    repetitions = num_retriggers,
                    card = card,
                }
            end
		end
	end,
})
