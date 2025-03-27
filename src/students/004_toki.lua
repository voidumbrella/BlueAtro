local j = {
	key = "toki",
	generate_ui = BlueAtro.generate_student_ui,
	atlas = "students_atlas",
	rarity = 3,
	cost = 10,
	pos = BlueAtro.id_to_atlas_pos(4),

	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

j.config = { extra = { psv_mult = 0, ex_discount_seconds = 10, ex_duration = 5, ex_discards_left = 0 } }

j.loc_vars = function(self, info_queue, card)
	return {
		blueatro_passive_vars = {
			card.ability.extra.psv_mult,
		},
		blueatro_ex_vars = {
			card.ability.extra.ex_duration,
			card.ability.extra.ex_discount_seconds,
			card.ability.extra.ex_discards_left > 0 and localize({
				type = "variable",
				key = "ba_k_left",
				vars = { card.ability.extra.ex_discards_left },
			}) or localize("ba_k_inactive"),
		},
	}
end

j.calculate = function(self, card, context)
	if context.joker_main and card.ability.extra.psv_mult > 0 then
		-- Give mult
		return {
			mult_mod = card.ability.extra.psv_mult,
			message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.psv_mult } }),
		}
	elseif context.pre_discard and not context.blueprint then
		-- Decrement EX skill counter when using a discard
		if card.ability.extra.ex_discards_left > 0 then
			card.ability.extra.ex_discards_left = card.ability.extra.ex_discards_left - 1
			if card.ability.extra.ex_discards_left == 0 then
				G.GAME.instagrad_timer.discard_time = G.GAME.instagrad_timer.discard_time
					+ card.ability.extra.ex_discount_seconds
			end
		end
	elseif context.discard and not context.blueprint then
		-- Gain mult from discarding
		local chips = math.floor(context.other_card:get_chip_bonus() / 2)
		card.ability.extra.psv_mult = card.ability.extra.psv_mult + chips
		return {
			message = localize({ type = "variable", key = "a_mult", vars = { card.ability.extra.psv_mult } }),
			card = card,
		}
	elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
		-- Reset at end of round
		card.ability.extra.psv_mult = self.config.extra.psv_mult
		return {
			message = localize("k_reset"),
			colour = G.C.MULT,
		}
	end
end

j.blueatro_ex_cost = 10
j.blueatro_ex_can_use = function(self, card)
	return card.ability.extra.ex_discards_left == 0
end
j.blueatro_ex_use = function(self, card)
	card.ability.extra.ex_discards_left = card.ability.extra.ex_duration
	G.GAME.instagrad_timer.discard_time =
		math.max(0, G.GAME.instagrad_timer.discard_time - card.ability.extra.ex_discount_seconds)

	local eval = function()
		return card.ability.extra.ex_discards_left > 0
	end
	juice_card_until(card, eval, true)
end

-- If card is added/destroyed with the EX skill active, update the effect accordingly
j.add_to_deck = function(self, card, from_debuff)
	if card.ability.extra.ex_discards_left > 0 then
		G.GAME.instagrad_timer.discard_time =
			math.max(0, G.GAME.instagrad_timer.discard_time - card.ability.extra.ex_discount_seconds)
	end
end
j.remove_from_deck = function(self, card, from_debuff)
	if card.ability.extra.ex_discards_left > 0 then
		G.GAME.instagrad_timer.discard_time = G.GAME.instagrad_timer.discard_time
			+ card.ability.extra.ex_discount_seconds
	end
end

SMODS.Joker(j)
