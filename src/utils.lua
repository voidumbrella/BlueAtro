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

BlueAtro.pop_card = function(card)
	G.E_MANAGER:add_event(Event({
		func = function()
			play_sound("tarot1")
			card.T.r = -0.2
			card:juice_up(0.3, 0.4)
			card.states.drag.is = true
			card.children.center.pinch.x = true
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				blockable = false,
				func = function()
					G.jokers:remove_card(card)
					card:remove()
					card = nil
					return true
				end,
			}))
			return true
		end,
	}))
end
