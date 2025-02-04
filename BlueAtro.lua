SMODS.Atlas({
	key = "jokers_atlas",
	path = "jokers.png",
	px = 71,
	py = 95,
})

local jokers = {
	"sobbing_face", -- 00
	"teabagging", -- 01
	"rollcake", -- 02
	"contraband", -- 03
	"hero", -- 04
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
