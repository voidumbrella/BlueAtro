SMODS.Sound({
	key = "e_gun_0",
	path = "e_gun_0.wav",
})
SMODS.Sound({
	key = "e_gun_1",
	path = "e_gun_1.wav",
})
SMODS.Sound({
	key = "e_gun_2",
	path = "e_gun_2.wav",
})

SMODS.Joker({
	key = "kuroko",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(37),
	config = { extra = { xmult = 1, xmult_gain = 0.4, counter = 0 } },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		local cae = card.ability.extra
		info_queue[#info_queue + 1] = { key = "eternal", set = "Other", vars = {} }
		return { vars = { cae.xmult, cae.xmult_gain, cae.counter } }
	end,
	calculate = function(self, card, context)
		local cae = card.ability.extra
		if context.joker_main and cae.xmult ~= 1 then
			return {
				x_mult = cae.xmult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
			}
		elseif context.buying_card and not context.blueprint and context.card ~= card then
			play_sound("blueatro_e_gun_" .. tostring(cae.counter))
			local killed_self = false
			cae.counter = cae.counter + 1
			if cae.counter >= 3 then
				cae.counter = 0
				for _, c in ipairs(G.jokers.cards) do
					if not c.ability.eternal and not c.getting_sliced then
						if c == card then
							killed_self = true
						end
						SMODS.destroy_cards(c)
						break
					end
				end
				if not killed_self then
					cae.xmult = cae.xmult + cae.xmult_gain
					return {
						message = localize("k_upgrade_ex"),
					}
				end
			else
				card:juice_up()
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
