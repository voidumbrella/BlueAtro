local j = {
	key = "neru",
	blueatro_passive_key = "blueatro_psv_neru",
	blueatro_ex_key = "blueatro_ex_neru",
	atlas = "students_atlas",
	config = { extra = { xmult = 1, xmult_gain = 0.5, ex_active = false } },
	rarity = 3,
	cost = 10,
	pos = BlueAtro.id_to_atlas_pos(0),
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	generate_ui = BlueAtro.generate_student_ui,

	loc_vars = function(self, info_queue, card)
		return {
			blueatro_passive_vars = {
				card.ability.extra.xmult_gain,
				card.ability.extra.xmult,
			},
			blueatro_ex_vars = {
				card.ability.extra.ex_active and localize("ba_k_active") or localize("ba_k_inactive"),
				colours = { card.ability.extra.ex_active and G.C.MULT or G.C.UI.TEXT_INACTIVE },
			},
		}
	end,
}

j.calculate = function(self, card, context)
	-- Passive Skill
	if context.joker_main and card.ability.extra.xmult > 1 then
		return {
			Xmult_mod = card.ability.extra.xmult,
			message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
		}
	elseif
		context.individual
		and context.cardarea == G.play
		and not context.blueprint
		and not context.other_card.debuff
		and context.other_card:get_id() == 14
	then
		card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
		return {
			message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
			card = card,
		}
	elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
		card.ability.extra.xmult = 1
		return {
			message = localize("k_reset"),
			colour = G.C.MULT,
		}
	end

	-- EX Skill
	if
		card.ability.extra.ex_active
		and context.cardarea == G.play
		and context.repetition
		and not context.other_card.debuff
		and context.other_card:get_id() == 14
	then
		return {
			message = localize("k_again_ex"),
			repetitions = 1,
			card = card,
		}
	end
	if context.after and not context.blueprint then
		card.ability.extra.ex_active = false
	end
end

j.blueatro_ex_cost = 3
j.blueatro_ex_can_use = function(self, card)
	return card.ability.extra.ex_active == false
end
j.blueatro_ex_use = function(self, card)
	card.ability.extra.ex_active = true
	juice_card_until(card, function()
		return card.ability.extra.ex_active
	end, true)
end

SMODS.Joker(j)
