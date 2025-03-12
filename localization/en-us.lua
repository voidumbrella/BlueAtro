return {
	descriptions = {
		Enhanced = {
			m_blueatro_pyroxene = {
				name = "Pyroxene Card",
				text = {
					"Spend {C:money}$#1#{} for",
					"{X:mult,C:white}X#2#{} Mult",
				},
			},
		},
		-- Text field is required because the game refuses to parse objects without it.
		-- Adding a dummy text is easier than patching that behavior.
		Joker = {
			j_blueatro_neru = {
				name = "Neru",
				text = { "" },
			},
		},
		BlueAtro_Passive = {
			blueatro_psv_neru = {
				name = "Callsign Double-O",
				text = {
					"This student has {X:mult,C:white}X#1#{} Mult",
					"for each {C:attention}Ace{} scored this round",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
			},
		},
		BlueAtro_EX = {
			blueatro_ex_neru = {
				name = "Unbridled Rage",
				text = {
					"Retrigger {C:attention}Aces{} for",
					"the next played hand",
					"{V:1}(#1#){}",
				},
			},
		},
	},
	misc = {
		achievement_descriptions = {},
		achievement_names = {},
		blind_states = {},
		challenge_names = {},
		collabs = {},
		dictionary = {
			ba_k_active = "Active!",
			ba_k_inactive = "Inactive",
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
