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
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
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
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.mult } }),
			}
		elseif context.remove_playing_cards and context.scoring_hand and not context.blueprint then
			local count = #context.removed
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * count
			-- Below is the "SMOD" way to do it I suppose, but it doesn't work. Bug?
			-- return {
			-- 	message = "Upgraded!",
			-- 	colour = G.C.MULT,
			-- 	card = card,
			-- }

			-- See functions/common_events.lua
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
