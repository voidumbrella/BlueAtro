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
	"sobbing_face",
	"teabagging",
	"hero",
	"white_rabbit",
	"crafting_chamber",
	"ornate_chair",
	"stargazing",
	"bookkeeping",
	-- Uncommons
	"rollcake",
	"pointman",
	"mob_of_mobs",
	"chicken_skewer",
	"signed_photocard",
	-- Rares
	"contraband",
	"elixir_of_youth",
	"cheerleader",
	"double_o",
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
