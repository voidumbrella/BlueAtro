SMODS.Joker({
	key = "chicken_skewer",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(14),
	config = { extra = { xmult = 2.5, xmult_loss = 0.05 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_loss } }
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult,
				colour = G.C.MULT,
				card = context.blueprint_card or card,
			}
		else
			if context.using_consumeable and not context.blueprint and not context.retrigger_joker then
				card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_loss

				if card.ability.extra.xmult <= 1 then
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
				else
					return {
						message = localize({
							type = "variable",
							key = "a_xmult_minus",
							vars = { card.ability.extra.xmult_loss },
						}),
						colour = G.C.RED,
					}
				end
			end
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
