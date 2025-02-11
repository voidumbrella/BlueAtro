--[[
--  Teabagging
--]]
SMODS.Joker({
	key = "teabagging",
	atlas = "jokers_atlas",
	pos = { x = 1, y = 0 },
	config = { extra = { mult = 0, mult_gain = 4 } },
	rarity = 2,
	cost = 4,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
			}
		elseif context.remove_playing_cards and not context.blueprint then
			if not context.removed or #context.removed == 0 then
				return
			end
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * #context.removed
			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
				card = card,
			}
		elseif context.joker_destroyed and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			-- Custom context so we do this ourselves, maybe SMOD can be patched so we can just return a message?
			card_eval_status_text(card, "extra", nil, nil, nil, {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
			})
		end
	end,
})
