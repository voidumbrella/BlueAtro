SMODS.Joker({
	key = "crayondrawing",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(27),
	config = { extra = { chips = 0, chips_gain = 3 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.chips > 0 then
			return {
				chips = card.ability.extra.chips,
				card = context.blueprint_card or card,
				colour = G.C.CHIPS,
			}
		elseif context.before and context.main_eval and not context.blueprint then
			-- FIXME: Suit check
			local suits = {}
			for _, scoring_card in ipairs(context.scoring_hand) do
				suits[scoring_card.base.suit] = true
			end
			local unique_suits = 0
			for _ in pairs(suits) do
				unique_suits = unique_suits + 1
			end
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain * unique_suits
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.CHIPS,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.CHIPS },
				{ ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
			},
		}
	end,
})
