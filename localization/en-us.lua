return {
	descriptions = {
		Back = {},
		Blind = {},
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
					"For every {C:attention}#2#{} scored cards,",
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
			j_blueatro_ornate_chair = {
				name = "Ornate Chair",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"at the end of the {C:attention}shop{}.",
					"Resets when shop is {C:attention}rerolled{}",
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
					"{C:attention}#2#{} cards, earn {C:money}$#1#{}.",
					"Number of cards",
					"hanges each round",
				},
			},
			j_blueatro_chicken_skewer = {
				name = "Chicken Skewer",
				text = {
					"{X:mult,C:white}X#1#{} Mult, loses {X:mult,C:white}X#2#{} Mult",
					"whenever a consumable is used",
				},
			},
			j_blueatro_signed_photocard = {
				name = "Signed Photocard",
				text = {
					"Played {C:attention}Queens{}",
					"permanently gain",
					"{C:mult}+#1#{} Mult when they score",
				},
			},
			j_blueatro_double_o = {
				name = "Double O",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult for this round",
					"whenever an {C:attention}Ace{} scores",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
			j_blueatro_calculator = {
				name = "Scientific Calculator",
				text = {
					"Each {C:attention}Pyroxene Card{} held in",
					"hand gives {C:chips}+#1#{} Chips",
				},
			},
			j_blueatro_sugar_rush = {
				name = "Sugar Rush",
				text = {
					"{X:mult,C:white}X#1#{} Mult, loses {X:mult,C:white}X#2#{} Mult",
					"after each {C:attention}hand{}.",
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
			j_blueatro_resupply_operation = {
				name = "Resupply Operation",
				text = {
					"If hand contains a {C:attention}Full House{}",
					"gain {C:attention}+#1#{} hand size.",
					"Resets after selecting a Blind",
					"{C:inactive}(Currently {C:attention}+#2#{C:inactive} hand size){}",
				},
			},
		},
		Other = {},
		Planet = {},
		Spectral = {},
		Stake = {},
		Tag = {},
		Tarot = {},
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
