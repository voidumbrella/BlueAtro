--[[
--  Hero
--]]
SMODS.Joker({
	key = "hero",
	atlas = "jokers_atlas",
	pos = { x = 4, y = 0 },
	config = { extra = { mult = 0, mult_gain = 1, cards_needed = 5, cards_scored = 0 } },
	rarity = 1,
	cost = 4,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_gain,
				card.ability.extra.cards_needed,
				card.ability.extra.mult,
				card.ability.extra.cards_needed - card.ability.extra.cards_scored,
			},
		}
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
			}
		elseif context.individual and context.cardarea == G.play and not context.blueprint then
			card.ability.extra.cards_scored = card.ability.extra.cards_scored + 1
			if card.ability.extra.cards_scored >= card.ability.extra.cards_needed then
				card.ability.extra.cards_scored = 0
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize("k_levelup"),
					colour = G.C.MULT,
					card = card,
					sound = "timpani",
				})
			else
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = string.format("%d/%d", card.ability.extra.cards_scored, card.ability.extra.cards_needed),
					card = card,
				})
			end
		end
	end,
})
