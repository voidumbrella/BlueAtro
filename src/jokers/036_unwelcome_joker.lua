SMODS.Sound({
	key = "e_explosion",
	path = "e_explosion.ogg",
})

SMODS.Joker({
	key = "unwelcome_joker",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(36),
	config = { extra = {} },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	loc_vars = function(self, info_queue, card) end,
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.play or context.cardarea == "unscored" then
			return {
				remove = true,
			}
		elseif context.after and context.main_eval then
			BlueAtro.pop_card(card, "blueatro_e_explosion")
		end
	end,
})
