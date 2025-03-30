SMODS.Joker({
	key = "guardian_angel",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(23),
	config = { extra = { mult = 0, mult_gain = 5 } },
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
    eternal_compat = false,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
	end,
	calculate = function(_, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult = card.ability.extra.mult,
				card = card,
				colour = G.C.MULT,
			}
		elseif (context.selling_self or
            (context.blueatro_destroying_joker and context.blueatro_destroyed_joker == self))
            and not context.blueprint
        then
            BlueAtro.serina_storage = BlueAtro.serina_storage or {}
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            card.sell_cost = 0
            BlueAtro.serina_storage[#BlueAtro.serina_storage + 1] = copy_card(card)
			-- TODO: Find something to hook into and return all these cards here
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
			},
		}
	end,
})
