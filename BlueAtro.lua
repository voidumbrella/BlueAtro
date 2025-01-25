SMODS.Atlas({
	key = "BlueAtro",
	path = "BlueAtro.png",
	px = 71,
	py = 95,
})

--[[
--  Sobbing Face
--]]
SMODS.Joker({
	key = "ba_sobface",
	atlas = "BlueAtro",
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = "Sobbing Face",
		text = {
			"{C:mult}+#1#{} Mult if all scored",
			"cards are {C:attention}7{} or below",
		},
	},
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

--[[
--  Teabagging
--]]
SMODS.Joker({
	key = "ba_teabag",
	atlas = "BlueAtro",
	pos = { x = 1, y = 0 },
	loc_txt = {
		name = "Teabagging",
		text = {
			"Gains {C:mult}+#2#{} Mult",
			"whenever a card or",
			"Joker is destroyed",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
		},
	},
	config = { extra = { mult = 0, mult_gain = 3 } },
	rarity = 2,
	cost = 4,
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
