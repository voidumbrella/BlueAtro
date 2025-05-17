local should_proc = function(discount)
	if not G.GAME or not G.GAME.current_round then
		return false
	end
	return #discount == G.GAME.current_round.blueatro_bookkeeping_count
end

SMODS.Joker({
	key = "bookkeeping",
	atlas = "jokers_atlas",
	pos = { x = 3, y = 1 },
	config = { extra = { dollar_gain = 4 } },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.dollar_gain,
				G.GAME.current_round.blueatro_bookkeeping_count,
			},
		}
	end,
	calculate = function(_, card, context)
		if context.pre_discard then
			if should_proc(G.hand.highlighted) then
				ease_dollars(card.ability.extra.dollar_gain)
				return {
					message = localize("$") .. card.ability.extra.dollar_gain,
					colour = G.C.MONEY,
					card = card,
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "+$", colour = G.C.MONEY },
				{ ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY },
			},
			reminder_text = {
				{ text = "(Discard ", scale = 0.25 },
				{ ref_table = "card.joker_display_values", ref_value = "count", scale = 0.25 },
				{ text = " cards)", scale = 0.25 },
			},
			calc_function = function(card)
				card.joker_display_values.count = G.GAME.current_round.blueatro_bookkeeping_count
				if not G.hand or not G.hand.highlighted then
					card.joker_display_values.dollars = 0
				else
					card.joker_display_values.dollars = should_proc(G.hand.highlighted)
							and card.ability.extra.dollar_gain
						or 0
				end
			end,
		}
	end,
})

-- Hook game to update var for Bookkeeping Jooker
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.blueatro_bookkeeping_count = 3
	return ret
end

-- Update number of cards every round
function SMODS.current_mod.reset_game_globals(run_start)
	G.GAME.current_round.blueatro_bookkeeping_count =
		math.floor(pseudorandom("aoi" .. G.GAME.round_resets.ante, 1, G.hand.config.highlighted_limit) + 0.5)
end
