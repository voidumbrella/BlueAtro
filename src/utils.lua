BlueAtro.id_to_atlas_pos = function(id)
	return { x = id % 10, y = math.floor(id / 10) }
end

BlueAtro.count_filtered = function(array, filter, count_debuffed)
	count_debuffed = count_debuffed or false
	local count = 0
	for _, x in ipairs(array) do
		if count_debuffed and x.debuff then
			goto continue
		end
		if filter(x) then
			count = count + 1
		end
		::continue::
	end
	return count
end

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

BlueAtro.pop_card = function(card, sound)
	sound = sound or "tarot1"
	G.E_MANAGER:add_event(Event({
		func = function()
			play_sound(sound)
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

BlueAtro.move_to_index = function(array, src_index, target_index)
	local to_wraparound = array[src_index]
	local step = src_index < target_index and 1 or -1

	for i = src_index, target_index - step, step do
		array[i] = array[i + step]
	end
	array[target_index] = to_wraparound
end

BlueAtro.get_card_pos = function(cardarea, card)
	for i = 1, #cardarea.cards do
		if cardarea.cards[i] == card then
			return i
		end
	end
end
