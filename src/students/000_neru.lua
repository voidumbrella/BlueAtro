local j = {
	key = "neru",
	generate_ui = BlueAtro.generate_student_ui,
	atlas = "students_atlas",
	rarity = 3,
	cost = 10,
	pos = BlueAtro.id_to_atlas_pos(0),

	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

j.config = { extra = { psv_xmult = 1, psv_xmult_gain = 0.25, ex_discard_count = 3 } }

j.loc_vars = function(self, info_queue, card)
	return {
		blueatro_passive_vars = {
			card.ability.extra.psv_xmult_gain,
			card.ability.extra.psv_xmult,
		},
		blueatro_ex_vars = {
			card.ability.extra.ex_discard_count,
		},
	}
end

j.calculate = function(self, card, context)
	if context.joker_main and card.ability.extra.psv_xmult > 1 then
		-- Give Xmult
		return {
			Xmult_mod = card.ability.extra.psv_xmult,
			message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.psv_xmult } }),
		}
	elseif context.discard and not context.blueprint then
		-- Gain Xmult for each card discarded
		card.ability.extra.psv_xmult = card.ability.extra.psv_xmult + card.ability.extra.psv_xmult_gain
		return {
			message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.psv_xmult } }),
			card = card,
		}
	elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
		-- Reset at end of round
		card.ability.extra.psv_xmult = self.config.extra.psv_xmult
		return {
			message = localize("k_reset"),
			colour = G.C.MULT,
		}
	end
end

j.blueatro_ex_cost = 2
j.blueatro_ex_can_use = function(self, card)
	return true
end
j.blueatro_ex_use = function(self, card)
	-- Code yoinked from Hook
	local _cards = {}
	for k, v in ipairs(G.hand.cards) do
		_cards[#_cards + 1] = v
		G.hand:remove_from_highlighted(v)
	end
	for i = 1, card.ability.extra.ex_discard_count do
		if G.hand.cards[i] then
			local selected_card, card_key = pseudorandom_element(_cards, pseudoseed("blueatro_neru"))
			G.hand:add_to_highlighted(selected_card, true)
			---@diagnostic disable-next-line: param-type-mismatch
			table.remove(_cards, card_key)
			play_sound("card1", 1)
		end
	end

	G.FUNCS.discard_cards_from_highlighted(nil)
end

SMODS.Joker(j)
