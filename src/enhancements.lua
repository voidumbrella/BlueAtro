SMODS.Atlas({
	key = "enhancements_atlas",
	path = "enhancements.png",
	px = 71,
	py = 95,
})

SMODS.Enhancement({
	key = "pyroxene",
	atlas = "enhancements_atlas",
	pos = { x = 0, y = 0 },
	config = { extra = { cost = 1, xmult = 2 } },
	loc_vars = function(_, info_queue, card)
		return { vars = { card.ability.extra.cost, card.ability.extra.xmult } }
	end,
	weight = 5,
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	calculate = function(self, card, context)
		if
			context.main_scoring
			and context.cardarea == G.play
			and (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) - card.ability.extra.cost >= G.GAME.bankrupt_at
		then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.cost
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				func = function()
					G.GAME.dollar_buffer = 0
					return true
				end,
			}))
			return {
				xmult = card.ability.extra.xmult,
				card = card,
				dollars = -card.ability.extra.cost,
			}
		end
	end,
})
