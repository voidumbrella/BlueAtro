--- Hooks that don't belong under specific Jokers.

-- After playing a hand, cards marked with `card.blueatro.return_to_hand` are returned to hand instead
G.FUNCS.draw_from_play_to_discard = function(_)
	local play_count = #G.play.cards
	local i = 1
	for _, card in ipairs(G.play.cards) do
		if (not card.shattered) and not card.destroyed then
			if card.blueatro and card.blueatro.return_to_hand then
				card.blueatro.return_to_hand = nil
				draw_card(G.play, G.hand, i * 100 / play_count, "up", true, card)
			else
				draw_card(G.play, G.discard, i * 100 / play_count, "down", false, card)
			end
			i = i + 1
		end
	end
end

-- Context for Joker destruction
local _card_remove = Card.remove
function Card:remove()
	if self.added_to_deck and self.ability.set == "Joker" and not G.CONTROLLER.locks.selling_card then
		SMODS.calculate_context({
			blueatro_destroying_joker = true,
			blueatro_destroyed_joker = self,
		})
	end
	return _card_remove(self)
end
