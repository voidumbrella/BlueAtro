BlueAtro = {}
BlueAtro.id_to_atlas_pos = function(id)
	-- I'm lazy
	return { x = id % 10, y = id / 10 }
end

SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32,
})

assert(SMODS.load_file("src/hooks.lua"))()
assert(SMODS.load_file("src/student.lua"))()

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
	"00_neru",
}
for _, name in ipairs(students) do
	local file_path = "src/students/" .. name .. ".lua"
	assert(SMODS.load_file(file_path))()
end

assert(SMODS.load_file("src/enhancements.lua"))()
