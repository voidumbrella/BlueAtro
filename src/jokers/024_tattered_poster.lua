SMODS.Joker({
	key = "tattered_poster",
	atlas = "jokers_atlas",
	pos = BlueAtro.id_to_atlas_pos(24),
	config = { },
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
    eternal_compat = false,
	perishable_compat = true,
	calculate = function(_, card, context)
		if context.blueatro_destroying_joker
            and context.blueatro_destroyed_joker == self
            and not context.blueprint
        then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({
                        set = "Joker",
                        key_append = "abydos_poster",
                        rarity = 1,
                    })
                    play_sound("generic1")
                    return true
                end,
            }))
		end
	end,

})
