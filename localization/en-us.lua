local loc = {
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
		-- See below the actual implementation of this.
		-- It's more convenient to organize by students and
		-- insert it into this table later.
		Joker = {},
		BlueAtro_Passive = {},
		BlueAtro_EX = {},
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
		v_dictionary = {
			ba_k_left = "#1# left",
		},
		v_text = {},
	},
}

local students = {
	neru = { -- 000
		name = "Neru",
		passive = {
			name = "Call Sign Double-O",
			text = {
				"Gains {X:mult,C:white}X#1#{} Mult",
				"for every card",
				"discarded this round",
				"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
			},
		},
		ex = {
			name = "Unbridled Rage",
			text = {
				"Discard {C:attention}#1#{} random",
				"cards in hand",
			},
		},
	},
	toki = { -- 004
		name = "Toki",
		passive = {
			name = "Call Sign Zero-Four",
			text = {
				"When a card is discarded,",
				"this gains half of its",
				"base {C:chips}Chip{} value as {C:mult}Mult{}",
				"until the end of round",
				"(rounded down)",
				"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
			},
		},
		ex = {
			name = "System: Abi-Eshuh",
			text = {
				"Next {C:attention}#1#{} discards",
				"cost {C:attention}#2#{} seconds less",
				"",
				"{C:inactive}(#3#){}",
			},
		},
	},
	moe = { -- 016
		name = "Moe",
		passive = {
			name = "Fire Support",
			text = {
				"{C:chips}+#1#{} chips",
			},
		},
		ex = {
			name = "Big Red Button",
			text = {
				"Passive gives {C:chips}+#1#{}",
				"additional chips until",
				"the end of round",
				"",
				"{C:green}#2# in #3#{} chance",
				"to reset it instead",
			},
		},
	},
}

-- Load student information into the localization table.
for key, profile in pairs(students) do
	loc.descriptions.Joker["j_blueatro_" .. key] = {
		name = profile.name,
		-- Text field is required because the game refuses to parse objects without it.
		-- Adding a dummy text is easier than patching that behavior.
		text = { "" },
	}

	loc.descriptions.BlueAtro_Passive["blueatro_psv_" .. key] = profile.passive
	loc.descriptions.BlueAtro_EX["blueatro_ex_" .. key] = profile.ex
end

return loc
