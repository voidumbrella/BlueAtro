-- See lovely/descartes.toml.
-- Why not use add_to_deck and remove_from_deck and set G.GAME.joker_rate to 0?
-- What if some other mod thing wants to modify that? Huh?
SMODS.Joker({
	key = "descartes",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(31),
	config = {},
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card) end,
	calculate = function(self, card, context) end,
})
