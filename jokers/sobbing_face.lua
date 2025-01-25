--[[
--  Sobbing Face
--]]
SMODS.Joker({
	key = "sobface",
	atlas = "jokers_atlas",
	pos = { x = 0, y = 0 },
	config = { extra = { mult = 11 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			local ok = true
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i]:get_id() > 7 then
					ok = false
				end
			end
			if ok then
				return {
					mult_mod = card.ability.extra.mult,
					message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
				}
			end
		end
	end,
})
