SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32,
})
SMODS.Atlas({
	key = "jokers_atlas",
	path = "jokers.png",
	px = 71,
	py = 95,
})

SMODS.Sound({
	key = "e_nihaha",
	path = "e_nihaha.ogg",
})

local jokers = {
	-- Commons
	"sobbing_face", -- 00
	"teabagging", -- 01
	"hero", -- 04
	"white_rabbit", -- 07
	"crafting_chamber", -- 08
	"ornate_chair", -- 09
	-- Uncommons
	"rollcake", -- 02
	"pointman", -- 06
	-- Rares
	"contraband", -- 03
	"elixir_of_youth", -- 05
}

local jokers_directory = SMODS.current_mod.path .. "/jokers"
for _, joker_name in ipairs(jokers) do
	local file_path = jokers_directory .. "/" .. joker_name .. ".lua"
	local file_type = NFS.getInfo(file_path).type
	if file_type == "file" then
		sendDebugMessage("Loaded " .. file_path)
		NFS.load(file_path)()
	end
end
