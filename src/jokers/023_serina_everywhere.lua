local _Game_start_run = Game.start_run
function Game:start_run(args)
	self.blueatro_serina_storage = CardArea(0, 0, self.CARD_W * 4.95, self.CARD_H * 0.95, {
		card_limit = 300,
		type = "title",
		highlight_limit = 1,
	})
	self.blueatro_serina_storage.states.visible = false
	BlueAtro.blueatro_serina_storage = self.blueatro_serina_storage

	_Game_start_run(self, args)
end

local _card_remove = Card.remove
function Card:remove()
	if self.config.center.key == "j_blueatro_serina" and self.added_to_deck then
		local copy = copy_card(self)
		copy.ability.extra.mult = self.ability.extra.mult + self.ability.extra.mult_gain
		copy.added_to_deck = nil
		BlueAtro.blueatro_serina_storage:emplace(copy)
	end

	return _card_remove(self)
end

local _smods_calculate_context = SMODS.calculate_context
SMODS.calculate_context = function(context, return_table)
	local ret = _smods_calculate_context(context, return_table)

	if context.end_of_round and #BlueAtro.blueatro_serina_storage.cards > 0 then
		local negatives_count = 0

		for _, card in ipairs(BlueAtro.blueatro_serina_storage.cards) do
			if card.edition and card.edition.negative then
				negatives_count = negatives_count + 1
			end
		end

		local slots_needed = #BlueAtro.blueatro_serina_storage.cards - negatives_count
		local available_slots = G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer)
		if slots_needed > available_slots then
			local destruction_count = slots_needed - available_slots
			for _, victim in ipairs(G.jokers.cards) do
				if not victim.ability.eternal and (not victim.edition or not victim.edition.negative) then
					victim:start_dissolve({ G.C.RED })
					destruction_count = destruction_count - 1
				end
				if destruction_count == 0 then
					break
				end
			end
			-- Sliced *something*?
			if destruction_count < slots_needed - available_slots then
				play_sound("slice1", 1.0)
			end
		end

		for _, card in ipairs(BlueAtro.blueatro_serina_storage.cards) do
			G.E_MANAGER:add_event(Event({
				func = function()
					if
						#G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
						or (card.edition and card.edition.negative)
					then
						BlueAtro.blueatro_serina_storage:remove_card(card)
						G.jokers:emplace(card)
						card:add_to_deck()
						card:juice_up(1, 0.5)
						play_sound("tarot1")
					else
						card:remove()
					end
					return true
				end,
			}))
		end
	end

	return ret
end

SMODS.Joker({
	key = "serina",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(23),
	config = { extra = { mult = 0, mult_gain = 3 } },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.sell_cost = 0
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult = card.ability.extra.mult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
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
