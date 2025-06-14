-- See lovely/helmet_gang.toml.

SMODS.Joker({
	key = "helmet_gang",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(29),
	config = { extra = { xmult = 2, price = 3 } },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card)
		local cae = card.ability.extra
		return { vars = { cae.xmult, cae.price } }
	end,
	calculate = function(self, card, context)
		local cae = card.ability.extra
		if context.joker_main then
			return {
				x_mult = cae.xmult,
				card = context.blueprint_card or card,
				colour = G.C.MULT,
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
