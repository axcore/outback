--[[
	Top End
--]]


-- localize math routines for performance
local math_random = math.random

-- top end
minetest.register_biome({
	name =              "top_end",
	node_top =          "base:dirt_with_grass",
	depth_top =         1,
	node_filler =       "base:sandstone",
	depth_filler =      3,
	node_stone =        "base:stone",
	node_river_water =  "base:muddy_water_source",
	node_riverbed =     "base:dirt",
	depth_riverbed =    1,
	y_min =             4,
	y_max =             31000,
	heat_point =        86,
	humidity_point =    86,
})


--[[
	Ores
--]]

-- Blob ore first to avoid other ores inside blobs

-- Copper
minetest.register_ore({
	ore_type =         "blob",
	ore =              "base:stone_with_copper",
	wherein =          {"base:stone"},
	clust_scarcity =   44 * 44 * 44,
	clust_size =       8,
	biomes =           {"top_end"},
	y_min =            -192,
	y_max =            0,
	noise_threshold =  1,
	noise_params =     {
		offset =   0,
		scale =    3,
		spread =   {x = 16, y = 16, z = 16},
		seed =     890,
		octaves =  3,
		persist =  0.6
	},
})

-- Diamond
minetest.register_ore({
	ore_type =        "scatter",
	ore =             "base:stone_with_diamond",
	wherein =         {"base:stone"},
	clust_scarcity =  40 * 40 * 40,
	clust_num_ores =  12,
	clust_size =      4,
	biomes =          {"top_end"},
	y_min =           -60,
	y_max =           17,
})

-- Uranium (Ranger)
minetest.register_ore({
	ore_type =         "scatter",
	ore =              "base:stone_with_uranium",
	wherein =          {"base:stone"},
	clust_scarcity =   28 * 28 * 28,
	clust_num_ores =   4,
	clust_size =       3,
	biomes =           {"top_end"},
	y_min =            -192,
	y_max =            19,
	noise_threshold =  0.6,
	noise_params =     {
		offset =   0,
		scale =    1,
		spread =   {x = 100, y = 100, z = 100},
		seed =     420,
		octaves =  3,
		persist =  0.7
		},
})

-- Uranium (Jabiluka)
minetest.register_ore({
	ore_type =         "scatter",
	ore =              "base:stone_with_uranium",
	wherein =          {"base:stone"},
	clust_scarcity =   26 * 26 * 26,
	clust_num_ores =   4,
	clust_size =       3,
	biomes =           {"top_end"},
	y_min =            -192,
	y_max =            6,
	noise_threshold =  0.6,
	noise_params =     {
		offset =   0,
		scale =    1,
		spread =   {x = 100, y = 100, z = 100},
		seed =     241,
		octaves =  3,
		persist =  0.7
		},
})


--[[
	Decorations
--]]

-- Grass
local function register_grass_decoration(offset, scale, length)
	minetest.register_decoration({
		deco_type =     "simple",
		place_on =      {"base:dirt_with_grass"},
		sidelen =       16,
		noise_params =  {
			offset =   offset,
			scale =    scale,
			spread =   {x = 200, y = 200, z = 200},
			seed =     329,
			octaves =  3,
			persist =  0.6
		},
		biomes =        {"top_end"},
		y_min =         4,
		y_max =         20,
		decoration =    "base:grass_"..length,
	})
end

local function register_dry_grass_decoration(offset, scale, length)
	minetest.register_decoration({
		deco_type =     "simple",
		place_on =      {"base:dirt_with_grass"},
		sidelen =       16,
		noise_params =  {
			offset =   offset,
			scale =    scale,
			spread =   {x = 200, y = 200, z = 200},
			seed =     329,
			octaves =  3,
			persist =  0.6
		},
		biomes =        {"top_end"},
		y_min =         18,
		y_max =         300,
		decoration =    "base:dry_grass_"..length,
	})
end

register_grass_decoration(-0.03,  0.09,  5)
register_grass_decoration(-0.015, 0.075, 4)
register_grass_decoration(0,      0.06,  3)
register_grass_decoration(0.015,  0.045, 2)
register_grass_decoration(0.03,   0.03,  1)

register_dry_grass_decoration(0.01, 0.05,  5)
register_dry_grass_decoration(0.03, 0.03,  4)
register_dry_grass_decoration(0.05, 0.01,  3)
register_dry_grass_decoration(0.07, -0.01, 2)
register_dry_grass_decoration(0.09, -0.03, 1)

-- Grass near rivers
local function register_rivergrass(length)
	plants_api.register_plant({
		nodes =     {"base:grass_"..length},
		cover =     0.33,
		density =   0.5,
		priority =  25,
		check = function(t, pos)
			return t.v2 > 0 and t.v2 < 0.02 and pos.y >= 4 and pos.y <= 300 and table.contains({"top_end"}, t.biome)
		end,
	})
end

register_rivergrass(5)
register_rivergrass(4)


-- Mitchell Grass
plants_api.register_plant({
	nodes =     {"base:mitchell_grass"},
	cover =     0.001,
	density =   0.01,
	priority =  35,
	check = function(t, pos)
		return t.v2 > 0 and t.v2 < 0.2 and pos.y >= 5 and pos.y <= 70 and table.contains({"top_end"}, t.biome)
	end,
})

-- Pink Mulla Mulla
plants_api.register_plant({
	nodes =     {"flowers:pink_mulla_mulla"},
	cover =     0.0015,
	density =   0.01,
	priority =  30,
	check = function(t, pos)
		return t.v4 > 0.3 and pos.y >= 5 and pos.y <= 70 and table.contains({"top_end"}, t.biome)
	end,
})

-- Spear Grass
plants_api.register_plant({
	nodes =     {"dryplants:spear_grass"},
	cover =     0.5,
	density =   0.33,
	priority =  90,
	check = function(t, pos)
		return t.v2 > 0.1 and t.v4 > 0.5 and t.v3 < 40 and pos.y >= 15 and pos.y <= 33 and table.contains({"top_end"}, t.biome)
	end,
})

-- Small sandstone rocks
local function register_small_sandstone_rocks(number)
	minetest.register_decoration({
		deco_type =   "simple",
		decoration =  "base:small_sandstone_rocks"..number,
		sidelen =     80,
		place_on =    {"base:dirt_with_grass"},
		fill_ratio =  0.002,
		y_min =       25,
		biomes =      {"top_end"},
		flags =       "place_center_x, place_center_z",
		rotation =    "random",
	})
end

register_small_sandstone_rocks(6)
register_small_sandstone_rocks(5)
register_small_sandstone_rocks(4)
register_small_sandstone_rocks(3)
register_small_sandstone_rocks(2)
register_small_sandstone_rocks(1)


--[[
	Trees
--]]

-- Arnhem Cypress Pine
plants_api.register_plant({
	nodes = {
		trunk =   "base:arnhem_cypress_pine_tree",
		leaves =  "base:arnhem_cypress_pine_leaves",
		air =     "air",
		ignore =  "ignore",
	},
	cover =     0.0005,
	density =   0.0025,
	priority =  40,
	check = function(t, pos)
		return pos.y >= 10 and pos.y <= 20 and table.contains({"top_end"}, t.biome)
	end,
	grow = function(nodes, pos, data, area)
		local height =  math_random(10, 15)
		local radius =  4
		base.make_conifer(pos, data, area, height, radius, nodes.trunk, nodes.leaves, nodes.air, nodes.ignore)
	end,
})

-- Arnhem Cypress Pine
plants_api.register_plant({
	nodes = {
		trunk =   "base:arnhem_cypress_pine_tree",
		leaves =  "base:arnhem_cypress_pine_leaves",
		air =     "air",
		ignore =  "ignore",
	},
	cover =     0.005,
	density =   0.005,
	priority =  35,
	check = function(t, pos)
		return pos.y >= 21 and pos.y <= 90 and table.contains({"top_end"}, t.biome)
	end,
	grow = function(nodes, pos, data, area)
		local height =  math_random(10, 15)
		local radius =  4
		base.make_conifer(pos, data, area, height, radius, nodes.trunk, nodes.leaves, nodes.air, nodes.ignore)
	end,
})

-- Boab Tree
plants_api.register_plant({
	nodes = {
		trunk =   "base:boab_tree",
		leaves =  "base:boab_leaves",
		air =     "air",
		ignore =  "ignore",
	},
	cover =     0.001,
	density =   0.0001,
	priority =  25,
	check = function(t, pos)
		return pos.y >= 5 and pos.y <= 30 and table.contains({"top_end"}, t.biome)
	end,
	grow = function(nodes, pos, data, area)
		local height =  math_random(5, 6)
		local radius =  math_random(4, 5)
		local limbs =   true
		base.make_boab(pos, data, area, height, radius, nodes.trunk, nodes.leaves, nodes.air, nodes.ignore, limbs)
	end,
})

-- Darwin Woollybutt
plants_api.register_plant({
	nodes = {
		trunk =   "base:darwin_woollybutt_tree",
		leaves =  "base:darwin_woollybutt_leaves",
		air =     "air",
		ignore =  "ignore",
	},
	cover =     0.0005,
	density =   0.0025,
	priority =  35,
	check = function(t, pos)
		return pos.y >= 5 and pos.y <= 10 and table.contains({"top_end"}, t.biome)
	end,
	grow = function(nodes, pos, data, area)
		local height =  math_random(8, 13)
		local radius =  math_random(4, 5)
		local limbs =   true
		base.make_tree(pos, data, area, height, radius, nodes.trunk, nodes.leaves, nodes.air, nodes.ignore, limbs)
	end,
})

-- Darwin Woollybutt
plants_api.register_plant({
	nodes = {
		trunk =   "base:darwin_woollybutt_tree",
		leaves =  "base:darwin_woollybutt_leaves",
		air =     "air",
		ignore =  "ignore",
	},
	cover =     0.005,
	density =   0.005,
	priority =  50,
	check = function(t, pos)
		return pos.y >= 11 and pos.y <= 35 and table.contains({"top_end"}, t.biome)
	end,
	grow = function(nodes, pos, data, area)
		local height =  math_random(8, 13)
		local radius =  math_random(4, 5)
		local limbs =   true
		base.make_tree(pos, data, area, height, radius, nodes.trunk, nodes.leaves, nodes.air, nodes.ignore, limbs)
	end,
})

-- River Oak
plants_api.register_plant({
	nodes = {
		trunk =   "base:river_oak_tree",
		leaves =  "base:river_oak_leaves",
		air =     "air",
		ignore =  "ignore",
	},
	cover =     0.005,
	density =   0.005,
	priority =  30,
	check = function(t, pos)
		return t.v2 > 0 and t.v2 < 0.03 and pos.y >= 5 and pos.y <= 120 and table.contains({"top_end"}, t.biome)
	end,
	grow = function(nodes, pos, data, area)
		local height =  math_random(5, 6)
		local radius =  math_random(2, 3)
		base.make_tree(pos, data, area, height, radius, nodes.trunk, nodes.leaves, nodes.air, nodes.ignore)
	end,
})

-- Swamp Bloodwood
plants_api.register_plant({
	nodes = {
		trunk =   "base:swamp_bloodwood_tree",
		leaves =  "base:swamp_bloodwood_leaves",
		air =     "air",
		ignore =  "ignore",
	},
	cover =     0.005,
	density =   0.005,
	priority =  55,
	check = function(t, pos)
		return t.v2 > 0.05 and t.v2 < 0.2 and t.v4 > 0.5 and pos.y >= 5 and pos.y <= 20 and table.contains({"top_end"}, t.biome)
	end,
	grow = function(nodes, pos, data, area)
		local height =  math_random(6, 8)
		local radius =  math_random(3, 4)
		local limbs =   true
		base.make_tree(pos, data, area, height, radius, nodes.trunk, nodes.leaves, nodes.air, nodes.ignore, limbs)
	end,
})
