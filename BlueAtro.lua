sendDebugMessage("Loading hooks", "BlueAtro")
assert(SMODS.load_file("src/hooks.lua"))()

SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32,
})

-- LOAD JOKERS --
SMODS.Atlas({
	key = "jokers_atlas",
	path = "jokers.png",
	px = 71,
	py = 95,
})
local jokers = {
	-- Commons
	"sobbing_face",
	"teabagging",
	"hero",
	"white_rabbit",
	"crafting_chamber",
	"slacker",
	"stargazing",
	"bookkeeping",
	"resupply_operation",
	-- Uncommons
	"rollcake",
	"pointman",
	"mob_of_mobs",
	"chicken_skewer",
	"signed_photocard",
	"scientific_calculator",
	"sugar_rush",
	"quick_reload",
	-- Rares
	"contraband",
	"elixir_of_youth",
	"cheerleader",
	"double_o",
	"nyans_dash",
	"account_reroll",
}
for _, name in ipairs(jokers) do
	local file_path = "src/jokers/" .. name .. ".lua"
	sendDebugMessage("Loading " .. file_path, "BlueAtro")
	assert(SMODS.load_file(file_path))()
end

sendDebugMessage("Loading enhancements", "BlueAtro")
assert(SMODS.load_file("src/enhancements.lua"))()
