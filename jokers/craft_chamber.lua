--[[
--  Craft Chamber
--]]
SMODS.Joker({
	key = "craft_chamber",
	atlas = "jokers_atlas",
	pos = { x = 8, y = 0 },
	config = { extra = { cards_sold = 0, cards_needed = 2 } },
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	loc_vars = function(_, info_queue, card)
		return {
			vars = { card.ability.extra.cards_needed, card.ability.extra.cards_sold },
		}
	end,
	calculate = function(_, card, context)
    if context.selling_card and context.card ==  and not context.blueprint then
			card.ability.extra.cards_sold = card.ability.extra.cards_sold + 1
			if card.ability.extra.cards_scored >= card.ability.extra.cards_needed then
				card.ability.extra.cards_scored = 0
        G.E_MANAGER:add_event(Event({
          func = function()
            SMODS.create_card({
              set = "Tarot",
              area = G.consumeables,
              key_append = "craft_chamber",
            })
          end
        }))    
				return {
					message = localize("k_plus_tarot"),
					colour = G.C.TAROT,
					card = card,
				}
      end
		end
	end,
})
