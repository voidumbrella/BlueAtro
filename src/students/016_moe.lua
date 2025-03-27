local j = {
	key = "moe",
	atlas = "students_atlas",
	config = { extra = { psv_chips = 25, odds = 4, ex_chip_gain = 25 } },
	rarity = 1,
	cost = 4,
	pos = BlueAtro.id_to_atlas_pos(16),
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	generate_ui = BlueAtro.generate_student_ui,

	loc_vars = function(self, info_queue, card)
		return {
			blueatro_passive_vars = {
				card.ability.extra.psv_chips,
			},
			blueatro_ex_vars = {
				card.ability.extra.ex_chip_gain,
				(G.GAME.probabilities.normal or 1),
				card.ability.extra.odds,
			},
		}
	end,
}

j.calculate = function(self, card, context)
	if context.joker_main then
		-- Give chips
		return {
			chip_mod = card.ability.extra.psv_chips,
			message = localize({ type = "variable", key = "a_chips", vars = { card.ability.extra.psv_chips } }),
		}
	elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
		-- Reset at the end of round
		card.ability.extra.psv_chips = self.config.extra.psv_chips
		return {
			message = localize("k_reset"),
			colour = G.C.MULT,
		}
	end
end

j.blueatro_ex_cost = 1
j.blueatro_ex_can_use = function(self, card)
	return true
end
j.blueatro_ex_use = function(self, card)
	if pseudorandom(pseudoseed("blueatro_moe")) < G.GAME.probabilities.normal / card.ability.extra.odds then
		card.ability.extra.psv_chips = self.config.extra.psv_chips
		SMODS.calculate_effect({
			message = localize("k_reset"),
			colour = G.C.RED,
		}, card)
	else
		card.ability.extra.psv_chips = card.ability.extra.psv_chips + card.ability.extra.ex_chip_gain
		SMODS.calculate_effect({
			message = localize("k_upgrade_ex"),
			colour = G.C.CHIPS,
		}, card)
	end
end

SMODS.Joker(j)
