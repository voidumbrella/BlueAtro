return {
	descriptions = {
		Back = {},
		Blind = {
			bl_blueatro_binah = {
				name = "Binah",
				text = {
					"Absurdly large blind",
					"{s:0.15}",
					"Playing a hand type",
					"unplayed this round",
					"halves required score",
				},
			},
			bl_blueatro_chesed = {
				name = "Chesed",
				text = {
					"Playing a hand increases",
					"required score by 15%",
				},
			},
			bl_blueatro_goz = {
				name = "Goz",
				text = {
					"After Play or Discard,",
					"flip and shuffle",
					"cards held in hand",
				},
			},
			bl_blueatro_perorodzilla = {
				name = "Perorodzilla",
				text = {
					"First scoring card",
					"of each hand is",
					"permanently debuffed",
				},
			},
			bl_blueatro_kurokage = {
				name = "Myouki Kurokage",
				text = {
					"Cards with rank scored",
					"this round are debuffed",
				},
			},
		},
		Edition = {},
		Enhanced = {
			m_blueatro_pyroxene = {
				name = "Pyroxene Card",
				text = {
					"Spend {C:money}$#1#{} for",
					"{X:mult,C:white}X#2#{} Mult",
				},
			},
		},
		Joker = {
			j_blueatro_sobface = {
				name = "Sobbing Face",
				text = {
					"Played {C:attention}number{} cards give",
					"{C:mult}+#1#{} Mult when scored",
				},
			},
			j_blueatro_teabagging = {
				name = "Teabagging",
				text = {
					"Whenever a card or",
					"Joker is {C:attention}destroyed{},",
					"this gains {C:mult}+#2#{} Mult",
					"{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} Mult{C:inactive})",
				},
			},
			j_blueatro_rollcake = {
				name = "Roll Cake",
				text = {
					"For next {C:attention}#1#{} rounds,",
					"{C:green}#2# in #3#{} chance to",
					"create a {C:planet}Planet{} card for",
					"the first played {C:attention}poker hand{}",
				},
			},
			j_blueatro_contraband = {
				name = "Contraband",
				text = {
					"If {C:attention}first hand{} of round",
					"scores both {C:attention}6{} and {C:attention}9{},",
					"create a {C:tarot}Death{}",
					"{C:inactive}(Must have room){}",
				},
			},
			j_blueatro_hero = {
				name = "Hero",
				text = {
					"When cards are scored {C:attention}#2#{} times,",
					"this gains {C:mult}+#1#{} Mult",
					"{C:inactive}(#4# cards left)",
					"{C:inactive}(Currently {C:mult}+#3#{}{C:inactive} Mult){}",
				},
			},
			j_blueatro_elixir_of_youth = {
				name = "Elixir of Youth",
				text = {
					"If {C:attention}first hand{} of round is a",
					"single {C:attention}face card{}, destroy it and",
					"add a random enhanced {C:attention}9{} to {C:attention}hand{}",
				},
			},
			j_blueatro_pointman = {
				name = "Pointman",
				text = {
					"This has {X:mult,C:white}X#1#{} Mult for",
					"each Joker to the right",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_blueatro_white_rabbit = {
				name = "White Rabbit",
				text = {
					"When {C:attention}Blind{} is selected,",
					"spend {C:money}$#1#{} to create",
					"a {C:tarot}Wheel of Fortune{}",
					"{C:inactive}(Must have room){}",
				},
			},
			j_blueatro_crafting_chamber = {
				name = "Crafting Chamber",
				text = {
					"After selling {C:attention}#1#{} cards,",
					"create a random {C:tarot}Tarot{} card",
					"{C:inactive}(Must have room){}",
					"{C:inactive}(#2# left){}",
				},
			},
			j_blueatro_nemugaki = {
				name = "Sleepy Brat",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"at the end of the {C:attention}shop{}",
					"if it has not been {C:attention}rerolled{}",
					"{C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult)",
				},
			},
			j_blueatro_stargazing = {
				name = "Stargazing",
				text = {
					"Using a {C:tarot}Tarot{} card creates",
					"a random {C:planet}Planet{} card",
					"{C:inactive}(Must have room){}",
				},
			},
			j_blueatro_mob_of_mobs = {
				name = "Mob of Mobs",
				text = {
					"When {C:attention}Blind{} is selected,",
					"this gains {X:mult,C:white}X#2#{} Mult for",
					"each {C:blue}Common{} Joker you have",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult{C:inactive})",
				},
			},
			j_blueatro_cheerleader = {
				name = "Cheerleader",
				text = {
					"Each scored card is retriggered",
					"by the number of cards held in hand",
					"with the {C:attention}same rank{}",
				},
			},
			j_blueatro_bookkeeping = {
				name = "Bookkeeping",
				text = {
					"When discarding exactly",
					"{C:attention}#2#{} cards, earn {C:money}$#1#{}",
					"Number of cards",
					"changes each round",
				},
			},
			j_blueatro_chicken_skewer = {
				name = "Chicken Skewer",
				text = {
					"{X:mult,C:white}X#1#{} Mult, loses {X:mult,C:white}X#2#{} Mult",
					"whenever a {C:attention}Joker{} is obtained",
				},
			},
			j_blueatro_photocard = {
				name = "Warakuhime Photocard",
				text = {
					"Played {C:attention}Queens{}",
					"permanently gain",
					"{C:chips}+#1#{} Chips when scored",
				},
			},
			j_blueatro_double_o = {
				name = "Callsign Double O",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult each card",
					"discarded this {C:attention}Ante{}",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_blueatro_calculator = {
				name = "Treasurer's Calculator",
				text = {
					"Each {C:attention}Pyroxene Card{} held in",
					"hand gives {C:chips}+#1#{} Chips",
				},
			},
			j_blueatro_sugar_rush = {
				name = "Sugar Rush",
				text = {
					"{X:mult,C:white}X#1#{} Mult, loses {X:mult,C:white}X#2#{} Mult",
					"after each hand played",
					"{C:inactive}(Will remain at X1){}",
					"Resets after beating a {C:attention}Boss Blind{}",
				},
			},
			j_blueatro_quick_reload = {
				name = "Quick Reload",
				text = {
					"If played hand contains a",
					"{C:attention}Two Pair{}, return the first",
					"two {C:attention}played cards{} back",
					"into hand after scoring",
				},
			},
			j_blueatro_avantgarde = {
				name = "Avant-Garde-kun",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"for each poker hand with",
					"level higher than played hand",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
				},
			},
			j_blueatro_nyans_dash = {
				name = "Nyan's Dash",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult for each hand",
					"matching the next hand in the combo",
					"Mult is halved when combo is dropped",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
					"",
					"Combo: {C:attention}#4#{}, {C:inactive,s:0.9}#5#, #6#, ... ",
				},
			},
			j_blueatro_account_reroll = {
				name = "Account Reroll",
				text = {
					"When {C:attention}rerolling{} the shop,",
					"{C:attention}destroys{} Joker to the right",
					"and creates a random Joker",
				},
			},
			j_blueatro_serina = {
				name = "Serina Everywhere",
				text = {
					"When sold or destroyed,",
					"this returns at the end of",
					"round and gains {C:mult}+#1#{} Mult",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
					" ",
					"If there is no room available,",
					"destroys the leftmost {C:attention}Joker{}",
					"to create space",
				},
			},
			j_blueatro_torn_poster = {
				name = "Torn Poster",
				text = {
					"Creates a random",
					"{C:red}Rare{} {C:attention}Joker{} when",
					"this is {C:attention}destroyed{}",
					"{C:inactive}(Must have room){}",
				},
			},
			j_blueatro_panic_shot = {
				name = "Panic Shot",
				text = {
					"{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult",
					"Selling a card increases",
					"the chance until end of round",
				},
			},
			j_blueatro_dictator = {
				name = "Dictator",
				text = {
					"Discarding exactly {C:attention}1{} card",
					"permanently {C:attention}debuffs{} it",
					"and gives {C:mult}+#1#{} Mult to",
					"all other cards in hand",
				},
			},
			j_blueatro_crayondrawing = {
				name = "Crayon Drawing",
				text = {
					"This Joker gains",
					"{C:chips}+#1#{} Chips for",
					"each unique suit",
					"in scoring hand",
					"{C:inactive}(Currently {C:chips}+#2#{}{C:inactive} Chips{C:inactive})",
				},
			},
			j_blueatro_vanivani = {
				name = "Vanitas Vanitatum",
				text = {
					"{X:mult,C:white}X#1#{} Mult if cards",
					"held in hand do not",
					"form any poker hand",
					"{C:inactive}(except {C:attention}High Card{C:inactive})",
				},
			},
			j_blueatro_helmet_gang = {
				name = "Helmat Gang",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"Must pay {C:money}$#2#{} to",
					"move a {C:attention}Joker{}",
				},
			},
			j_blueatro_iridescence = {
				name = "Iridescence",
				text = {
					"At the end of each round,",
					"creates a random {C:attention}Eternal{}",
					"{C:spectral}Spectral{} card",
				},
			},
			j_blueatro_descartes = {
				name = "Descartes",
				text = {
					"Shops do not",
					"offer {C:attention}Jokers{}",
				},
			},
			j_blueatro_dowsing_rods = {
				name = "Dowsing Rods",
				text = {
					"When {C:attention}Blind{} is selected,",
					"cards with the the least common {C:attention}ranks{}",
					"are shuffled to the top of the deck",
					"{C:inactive}(Ties are shuffled together)",
				},
			},
		},
		Other = {},
		Planet = {},
		Spectral = {},
		Stake = {},
		Tag = {},
		Tarot = {
			c_blueatro_whale = {
				name = "The Whale",
				text = {
					"Enhances {C:attention}#1#{} selected card",
					"into a {C:attention}Pyroxene Card",
				},
			},
		},
		Voucher = {},
	},
	misc = {
		achievement_descriptions = {},
		achievement_names = {},
		blind_states = {},
		challenge_names = {},
		collabs = {},
		dictionary = {
			k_shikei = "SHIKEI!",
			k_levelup = "Panpakapan!",
			k_nihaha = "Nihaha!",
			k_sugar_replenished = "Sugar Replenished!",
			k_rerolled = "Rerolled!",
			k_purge = "Purge!",
		},
		high_scores = {},
		labels = {},
		poker_hand_descriptions = {},
		poker_hands = {},
		quips = {},
		ranks = {},
		suits_plural = {},
		suits_singular = {},
		tutorial = {},
		v_dictionary = {},
		v_text = {},
	},
}
