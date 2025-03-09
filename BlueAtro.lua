BA = {}

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
	key = "students_atlas",
	path = "students.png",
	px = 71,
	py = 95,
})
local students = {
	-- Commons
	-- Uncommons
	-- Rares
}
sendDebugMessage("Loading students", "BlueAtro")
for _, name in ipairs(students) do
	local file_path = "src/students/" .. name .. ".lua"
	assert(SMODS.load_file(file_path))()
end

sendDebugMessage("Loading enhancements", "BlueAtro")
assert(SMODS.load_file("src/enhancements.lua"))()
