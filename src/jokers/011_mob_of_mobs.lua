SMODS.Joker({
	key = "mob_of_mobs",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(11),
	config = { extra = { xmult = 1, xmult_gain = 0.1 } },
	rarity = 2,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
	end,
	calculate = function(_, card, context)
		if context.setting_blind and G.jokers and not context.blueprint and not context.retrigger_joker then
			local common_count = 0
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].config.center.rarity == 1 then
					common_count = common_count + 1
				end
			end
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * common_count
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
				colour = G.C.MULT,
				card = card,
			}
		elseif context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
				colour = G.C.MULT,
				card = context.blueprint_card or card,
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "X", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.MULT },
			},
		}
	end,
})
