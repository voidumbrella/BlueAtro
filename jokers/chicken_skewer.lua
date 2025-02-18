SMODS.Joker({
	key = "chicken_skewer",
	atlas = "jokers_atlas",
	pos = { x = 3, y = 1 },
	config = { extra = { xmult = 2.5, xmult_loss = 0.1 } },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_loss }}
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			return {
				Xmult_mod = xmult,
				message = localize({ type = "variable", key = "a_xmult", vars = { xmult } }),
			}
		else if context.using_consumeable and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_loss
			if card.ability.extra.xmult <= 1.0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								SMODS.calculate_context( {
									joker_destroyed = true,
									destroyed = card,
								})
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				return {
					message = localize("k_eaten_ex"),
					colour = G.C.FILTER,
				}
			end
		end
	end,
	joker_display_def = function(JokerDisplay)
		return {
			text = {
				{ text = "X", colour = G.C.MULT },
				{ ref_table = "card.abiltiy.extra", ref_value = "xmult", colour = G.C.MULT },
			},
		}
	end,
})
