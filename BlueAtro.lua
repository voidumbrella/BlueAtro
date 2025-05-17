BlueAtro = {}
BlueAtro.id_to_atlas_pos = function(id)
	return { x = id % 10, y = math.floor(id / 10) }
end

SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32,
})

SMODS.Atlas({
	key = "blueatro_blind_atlas",
	path = "blinds.png",
	px = 34,
	py = 34,
	atlas_table = "ANIMATION_ATLAS",
	frames = 21,
})

SMODS.Atlas({
	key = "blueatro_joker_atlas",
	path = "jokers.png",
	px = 71,
	py = 95,
})

assert(SMODS.load_file("src/hooks.lua"))()
assert(SMODS.load_file("src/utils.lua"))()

assert(SMODS.load_file("src/enhancements.lua"))()
assert(SMODS.load_file("src/tarots.lua"))()

local function load_dir(dir, sort)
	sort = (sort == nil) and true or sort
	local file_list = NFS.getDirectoryItemsInfo(SMODS.current_mod.path .. "/" .. dir)
	local to_load = {}
	for i = 1, #file_list do
		local file_name = file_list[i].name
		if file_name:sub(-4) == ".lua" then
			to_load[#to_load + 1] = file_name
		end
	end
	if sort then
		table.sort(to_load)
	end

	for _, file_name in ipairs(to_load) do
		assert(SMODS.load_file(dir .. "/" .. file_name))()
	end
end

load_dir("src/jokers")
load_dir("src/blinds")
