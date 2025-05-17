local function should_proc(held_cards)
	if held_cards == nil or #held_cards == 0 then
		return false
	end
	local poker_hand, _, _, _, _ = G.FUNCS.get_poker_hand_info(held_cards)
	return poker_hand == "High Card"
end

SMODS.Joker({
	key = "vanivani",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(28),
	config = { extra = { xmult = 3 } },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and should_proc(G.hand.cards) then
			return {
				x_mult = card.ability.extra.xmult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "X", colour = G.C.MULT },
				{ ref_table = "card.joker_display_values", ref_value = "xmult", colour = G.C.MULT },
			},
			calc_function = function(card)
				local unhighlighted = {}
				for _, held in ipairs(G.hand.cards) do
					if not held.highlighted then
						unhighlighted[#unhighlighted + 1] = held
					end
				end
				card.joker_display_values.xmult = should_proc(unhighlighted) and card.ability.extra.xmult or 1.0
			end,
		}
	end,
})
