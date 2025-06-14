SMODS.Joker({
	key = "dowsing_rods",
	atlas = "blueatro_joker_atlas",
	pos = BlueAtro.id_to_atlas_pos(32),
	config = {},
	rarity = 2,
	cost = 5,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	loc_vars = function(self, info_queue, card) end,
	calculate = function(self, card, context) end,
})

local _CardArea_shuffle = CardArea.shuffle
function CardArea:shuffle(seed)
	if self == G.deck and #SMODS.find_card("j_blueatro_dowsing_rods") > 0 and G.STATE == G.STATES.DRAW_TO_HAND then
		local rods = SMODS.find_card("j_blueatro_dowsing_rods")
		rods[1]:juice_up()
		play_sound("generic1.ogg")

		-- Determine rank frequency
		local ranks = {}
		for _, card in ipairs(G.deck.cards) do
			if not SMODS.has_no_rank(card) then
				local rank = card:get_id()
				ranks[rank] = (ranks[rank] or 0) + 1
			end
		end

		-- Find minimum
		local minimum = math.huge
		for rank, count in pairs(ranks) do
			if count < minimum then
				minimum = count
			end
		end

		-- Rig deck by floating some cards to the top...
		local topdeck = {}
		local rigged_deck = {}
		for _, card in ipairs(G.deck.cards) do
			local rank = card:get_id()
			if SMODS.has_no_rank(card) or ranks[rank] ~= minimum then
				rigged_deck[#rigged_deck + 1] = card
			end
			if ranks[rank] == minimum then
				topdeck[#topdeck + 1] = card
			end
		end
		pseudoshuffle(topdeck, pseudoseed(seed or "shuffle"))
		pseudoshuffle(rigged_deck, pseudoseed(seed or "shuffle"))

		for _, card in ipairs(topdeck) do
			rigged_deck[#rigged_deck + 1] = card
		end

		G.deck.cards = rigged_deck
		G.deck:set_ranks()
	else
		_CardArea_shuffle(self, seed)
	end
end
