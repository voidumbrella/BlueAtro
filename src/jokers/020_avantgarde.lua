local function get_lower_hands_count(scoring_name)
	local level = G.GAME.hands[scoring_name] and G.GAME.hands[scoring_name].level or 1
	local hand_count = 0
	for k, v in pairs(G.GAME.hands) do
		if v.visible and v.level > level then
			hand_count = hand_count + 1
		end
	end
	return hand_count
end

SMODS.Joker({
	key = "avantgarde",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(20),
	config = { extra = { mult_gain = 2, mult = 0 } },
	rarity = 3,
	cost = 11,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult = card.ability.extra.mult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
		elseif context.before then
			local lower_hands = get_lower_hands_count(context.scoring_name)
			if lower_hands == 0 then
				return
			end

			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * lower_hands

			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
				card = card,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.MULT },
				{ ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
			},
			calc_function = function(card)
				if next(G.play.cards) then
					return
				end

				local text, _, _ = JokerDisplay.evaluate_hand()
				if text ~= "Unknown" and G.GAME and G.GAME.hands[text] then
					local count = get_lower_hands_count(text)
					card.joker_display_values.mult = card.ability.extra.mult + card.ability.extra.mult_gain * count
				else
					card.joker_display_values.mult = card.ability.extra.mult
				end
			end,
		}
	end,
})
