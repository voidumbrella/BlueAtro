local function should_proc(scoring_name)
	local level = G.GAME.hands[scoring_name].level or 1
	for k, v in pairs(G.GAME.hands) do
		if k ~= scoring_name and v.visible and v.level <= level then
			return false
		end
	end
	return true
end

SMODS.Joker({
	key = "avantgarde",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(20),
	config = { extra = { xmult = 1.618 } },
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and should_proc(context.scoring_name)
		then
			local xmult = calculate_xmult(card)
			return {
				x_mult = card.ability.extra.xmult,
				colour = G.C.RED,
				card = card,
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
				-- TODO: Calculate XMult
				card.joker_display_values.xmult = 1
			end,
		}
	end,
})
