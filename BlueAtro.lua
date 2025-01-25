SMODS.Atlas({
	key = "jokers_atlas",
	path = "jokers.png",
	px = 71,
	py = 95,
})

local jokers_directory = SMODS.current_mod.path .. "/jokers"
for _, filename in ipairs(NFS.getDirectoryItems(jokers_directory)) do
	local file_path = jokers_directory .. "/" .. filename
	local file_type = NFS.getInfo(file_path).type
	if file_type == "file" then
		sendDebugMessage("Loaded " .. file_path)
		NFS.load(file_path)()
	end
end
