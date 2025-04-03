SMODS.Atlas({
	key = "tarots_atlas",
	path = "tarots.png",
	px = 71,
	py = 95,
})

SMODS.Consumable({
	key = "whale",
	set = "Tarot",
	atlas = "tarots_atlas",
	pos = { x = 0, y = 0 },
	config = { mod_conv = "m_blueatro_pyroxene", max_highlighted = 1 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_blueatro_pyroxene
		return { vars = { card.ability.max_highlighted } }
	end,
})
