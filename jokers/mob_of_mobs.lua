--[[
--  Mob of Mobs
--]]
SMODS.Joker({
	key = "mob_of_mobs",
	atlas = "jokers_atlas",
	pos = { x = 1, y = 1 },
	config = { extra = { xmult = 1, xmult_gain = 0.05 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
	end,
	calculate = function(_, card, context)
		if context.setting_blind and G.jokers and not context.blueprint then
			local common_count = 0
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].config.center.rarity == 1 then
					common_count = common_count + 1
				end
			end
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * common_count
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
				colour = G.C.MULT,
				card = card,
			}
		elseif context.joker_main then
			return {
				Xmult_mod = card.ability.extra.xmult,
				message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
			}
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "X", colour = G.C.MULT },
				{ ref_table = "card.ability.extra", ref_value = "xmult", colour = G.C.MULT },
			},
		}
	end,
})
