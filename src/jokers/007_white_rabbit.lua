SMODS.Sound({
	key = "e_nihaha",
	path = "e_nihaha.ogg",
})

SMODS.Joker({
	key = "white_rabbit",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(7),
	config = { extra = { cost = 1 } },
	rarity = 1,
	cost = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(_, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_wheel_of_fortune
		return { vars = { card.ability.extra.cost } }
	end,
	calculate = function(_, card, context)
		if
			context.setting_blind
			and (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) - card.ability.extra.cost >= G.GAME.bankrupt_at
			and (#G.consumeables.cards + (G.GAME.consumeable_buffer or 0)) < G.consumeables.config.card_limit
		then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.cost
			G.GAME.consumeable_buffer = (G.GAME.consumeable_buffer or 0) + 1
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.0,
				func = function()
					local _card = SMODS.add_card({ set = "Tarot", key = "c_wheel_of_fortune" })
					G.GAME.dollar_buffer = 0
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
			play_sound("blueatro_e_nihaha", 1.0, 0.6)
			return {
				message = localize("k_nihaha"),
				colour = G.C.SECONDARY_SET.Tarot,
				card = context.blueprint_card or card,
				dollars = -card.ability.extra.cost,
			}
		end
	end,
})
