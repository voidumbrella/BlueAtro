local should_proc = function(discards)
	if not G.GAME or G.GAME.current_round or not G.GAME.current_round.joker_bookkeeping then
		return false
	end
	return #discards == G.GAME.current_round.joker_bookkeeping.cards
end

SMODS.Joker({
	key = "bookkeeping",
	atlas = "jokers_atlas",
	pos = { x = 1, y = 3 },
	config = { extra = { dollar_gain = 2 } },
	rarity = 1,
	cost = 2,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return {
			vars = {
				card.ability.extra.dollar_gain,
				G.GAME.current_round.joker_bookkeeping.cards
			}
		}
	end,
	calculate = function(_, card, context)
		if context.pre_discard and context.cardarea == G.play then
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
				{ text = "(< 7)", scale = 0.35 },
			},
			calc_function = function(card)
				if not G.hand or not G.hand.highlighted then
					card.joker_display_values.dollars = 0
				else
					card.joker_display_values.dollars = should_proc(G.hand.highlighted) and card.ability.extra.dollar_gain or 0
				end
			end,
		}
	end,
})

-- Hook game to update var for Bookkeeping Jooker
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.joker_bookkeeping = { cards = 1 }
	return ret
end

-- Update # of cards every round
function SMODS.current_mod.reset_game_globals(_run_start)
	G.GAME.current_round.joker_bookkeeping = {
		pseudorandom_element({1, 2, 3, 4, 5}, pseudoseed('aoi' .. G.GAME.round_resets.ante))
	}
end
