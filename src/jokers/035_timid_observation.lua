SMODS.Joker({
	key = "timid_observation",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(35),
	config = { extra = { chips = 0, chips_gain = 2 } },
	rarity = 1,
	cost = 5,
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
		elseif
			context.post_trigger
			and context.other_card ~= card
			and not context.blueprint
			and context.other_ret.jokers
		then
			local t = context.other_ret.jokers
			local triggers = 0
			if t.chips or t.chip_mod then
				triggers = triggers + 1
			end
			if t.mult or t.mult_mod then
				triggers = triggers + 1
			end
			while triggers > 0 do
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain * triggers
				SMODS.calculate_effect({
					message = localize("k_upgrade_ex"),
					colour = G.C.CHIPS,
				}, card)
				triggers = triggers - 1
			end
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
