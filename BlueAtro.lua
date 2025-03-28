BlueAtro = {}
BlueAtro.id_to_atlas_pos = function(id)
	return { x = id % 10, y = math.floor(id / 10) }
end

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
local jokers = {}

local path = SMODS.current_mod.path .. "/src/jokers"
local files = NFS.getDirectoryItemsInfo(path)
for i = 1, #files do
	local file_name = files[i].name
	if file_name:sub(-4) == ".lua" then
		jokers[#jokers + 1] = file_name
	end
end
table.sort(jokers)

for _, file_name in ipairs(jokers) do
	sendDebugMessage("Loading " .. file_name, "BlueAtro")
	assert(SMODS.load_file("src/jokers/" .. file_name))()
end

-- LOAD ENHANCEMENTS --
sendDebugMessage("Loading enhancements", "BlueAtro")
assert(SMODS.load_file("src/enhancements.lua"))()
