--[[
	Great Barrier Reef
--]]


-- Localize math routines for performance.
local math_random = math.random

-- great barrier reef
minetest.register_biome({
	name =             "great_barrier_reef",
	node_top =         "base:sand",
	depth_top =        2,
	node_filler =      "base:basalt",
	depth_filler =     3,
	node_stone =       "base:stone",
	node_river_water = "base:river_water_source",
	node_riverbed =    "base:sand",
	depth_riverbed =   1,
	y_min =            -31,
	y_max =            3,
	heat_point =       88,
	humidity_point =   73,
})


--[[
	Ores
--]]

-- Blob ore first to avoid other ores inside blobs.

minetest.register_ore({
	ore_type =       "scatter",
	ore =            "sea:woodship",
	wherein =        "base:sand",
	clust_scarcity = 27000,
	clust_num_ores = 1,
	clust_size =     12,
	biomes =         {"great_barrier_reef"},
	y_min =          -31,
	y_max =          -6,
})


--[[
	Decorations
--]]



--[[
	Trees
--]]

-- Placeholder for Palm Tree
-- Awaiting a fix for L-system lighting bug #3421.
-- https://github.com/minetest/minetest/issues/3421


--[[
	ABM's
--]]

minetest.register_abm({
	nodenames =  {"sea:woodship"},
	interval =   1,
	chance =     1,
	action = function(pos, node)
		local yp = {x = pos.x, y = pos.y + 3, z = pos.z}
		if node.name == "sea:woodship" and
				minetest.get_node(yp).name == "base:water_source" then
			sea.place_woodship(pos)
		end
	end
})


