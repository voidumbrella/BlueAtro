BlueAtro.ease_blind_chips = function(target)
	local decreasing = target < G.GAME.blind.chips
	local diff = target - G.GAME.blind.chips

	local event
	event = Event({
		trigger = "after",
		blocking = true,
		delay = 0.1,
		func = function()
			G.GAME.blind.chips = G.GAME.blind.chips + diff / 10
			if (decreasing and G.GAME.blind.chips > target) or (not decreasing and G.GAME.blind.chips < target) then
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
				play_sound("chips1")
				event.start_timer = false
			else
				G.GAME.blind.chips = target
				G.GAME.blind.chip_text = number_format(target)
				G.GAME.blind:wiggle()
				return true
			end
		end,
	})
	G.E_MANAGER:add_event(event)
end
