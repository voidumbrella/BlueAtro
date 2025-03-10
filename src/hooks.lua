-- Contains misc. hooking functions that don't really fit anywhere

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.blueatro = {}
	ret.current_round.blueatro.cost_meter = { cur = 0, max = 10, inc = 1 }
	ret.current_round.blueatro.bookkeeping_count = 3
	ret.current_round.blueatro.yuzu_combo = { "High Card", "Three of a Kind", "Two Pair" }
	return ret
end

-- Update number of cards every round
function SMODS.current_mod.reset_game_globals(run_start)
	G.GAME.current_round.blueatro.bookkeeping_count =
		math.floor(pseudorandom("aoi" .. G.GAME.round_resets.ante, 1, G.hand.config.highlighted_limit) + 0.5)
end

local _smods_calculate_context = SMODS.calculate_context
SMODS.calculate_context = function(context, return_table)
	local ret = _smods_calculate_context(context, return_table)

	-- BEGIN: Update round-global variables after each hand scores
	if context.after then
		-- BEGIN: Increment cost meter
		local meter = G.GAME.current_round.blueatro.cost_meter
		meter.cur = math.min(meter.max, meter.cur + meter.inc)
		print(G.GAME.current_round.blueatro.cost_meter)
		-- END: Increment cost meter

		-- BEGIN: Yuzu's Combo
		local movelist = { -- World's dumbest weighting algorithm
			"High Card",
			"Pair",
			"Pair",
			"Pair",
			"Two Pair",
			"Two Pair",
			"Two Pair",
			"Two Pair",
			"Three of a Kind",
			"Straight",
			"Straight",
			"Flush",
			"Flush",
			"Flush",
			"Full House",
			-- hands below omitted intentionally
			-- "Four of a Kind",
			-- "Straight Flush"
		}
		local next = pseudorandom_element(movelist, pseudoseed("yuzu_combo"))
		local yuzu_combo = G.GAME.current_round.blueatro.yuzu_combo
		table.remove(yuzu_combo, 1)
		yuzu_combo[#yuzu_combo + 1] = next
		--END: Nyan's Dash
	end
	-- END: Update round-global variables after each hand
end

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
function Card.remove(self)
	if self.added_to_deck and self.ability.set == "Joker" and not G.CONTROLLER.locks.selling_card then
		SMODS.calculate_context({
			blueatro = {
				destroying_joker = true,
				destroyed_joker = self,
			},
		})
	end

	return _card_remove(self)
end
