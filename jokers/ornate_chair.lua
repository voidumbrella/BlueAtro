--[[
--  Ornate Chair
--]]
SMODS.Joker({
	key = "ornate_chair",
	atlas = "jokers_atlas",
	pos = { x = 9, y = 0 },
	config = { extra = { mult = 0, mult_gain = 3 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_gain,
				card.ability.extra.mult,
			},
		}
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
			}
		elseif context.ending_shop and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
				card = card,
			}
		elseif context.reroll_shop and not context.blueprint then
			card.ability.extra.mult = 0
			SMODS.calculate_effect({ message = localize("k_reset"), colour = G.C.MULT, card = card })
		end
	end,
})
