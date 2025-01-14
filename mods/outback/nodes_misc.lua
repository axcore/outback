--[[
	Miscellaneous nodes
--]]

minetest.register_node("outback:salt", {
	description = "Salt",
	drawtype = "plantlike",
	visual_scale = 0.6,
	tiles = {"ob_salt.png"},
	inventory_image = "ob_salt.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy = 3, dig_immediate = 3, flammable = 1},
	on_use = minetest.item_eat(1),
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-3/32, -8/16, -3/32, 3/32, -4/16, 3/32},
	},
	collision_box = {
		type = "fixed",
		fixed = {-3/32, -8/16, -3/32, 3/32, -4/16, 3/32},
	},
})

minetest.register_node("outback:opal",{
	description = "Opal",
	drawtype = "mesh",
	mesh = "ob_pebble.obj",
	tiles = {"ob_opal.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky=2, stone=1, dig_immediate = 1},
	selection_box = {
		type = "fixed",
		fixed = {-5/16, -8/16, -6/16, 5/16, -1/32, 5/16},
	},
	collision_box = {
		type = "fixed",
		fixed = {-5/16, -8/16, -6/16, 5/16, -1/32, 5/16},
	},
	sounds = default.node_sound_stone_defaults(),
})


--[[
	Small Rocks
--]]

-- Place a small nodebox.
local function small_cube(grid, pos, diameters)
	local rock = {}

	rock[1] = pos.x
	rock[2] = pos.y
	rock[3] = pos.z
	rock[4] = pos.x + diameters.x
	rock[5] = pos.y + diameters.y
	rock[6] = pos.z + diameters.z
	outback.push(grid, rock)
end

-- Small red rocks
local default_grid_red_rocks

for grid_count = 1, 6 do
	local grid = {}
	for rock_count = 2, math.random(1, 4) + 1 do
		local diameter = math.random(15, 25) / 100
		local x = math.random(1, 80) / 100 - 0.5
		local z = math.random(1, 80) / 100 - 0.5
		small_cube(grid, {x = x, y = -0.5, z = z}, {x = diameter, y = diameter, z = diameter})
	end

	minetest.register_node("outback:small_red_rocks"..grid_count, {
		description = "Small Red Rocks",
		tiles = {"technic_granite.png"},
		is_ground_content = true,
		walkable = false,
		paramtype = "light",
		drawtype = "nodebox",
		buildable_to = true,
		node_box = {type = "fixed", fixed = grid},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {stone = 1, oddly_breakable_by_hand = 3},
		drop = "outback:small_red_rocks",
		sounds = default.node_sound_stone_defaults(),
	})

	default_grid_red_rocks = grid
end

minetest.register_node("outback:small_red_rocks", {
	description = "Small Red Rocks",
	tiles = {"technic_granite.png"},
-- @@@ Josselin2
--	inventory_image = "ob_small_red_rocks.png",
	is_ground_content = true,
	walkable = false,
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = default_grid_red_rocks},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	groups = {stone = 1, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local player_name = placer:get_player_name()
		-- place a random small red rocks node
		if not minetest.is_protected(pos, player_name) then
			minetest.set_node(pos, {name = "outback:small_red_rocks"..math.random(1, 6)})
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
		else
			minetest.chat_send_player(player_name, "Node is protected")
			minetest.record_protection_violation(pos, player_name)
		end
		return itemstack
	end
})

-- Small sandstone rocks
local default_grid_sandstone_rocks

for grid_count = 1, 6 do
	local grid = {}
	for rock_count = 2, math.random(1, 4) + 1 do
		local diameter = math.random(15, 25) / 100
		local x = math.random(1, 80) / 100 - 0.5
		local z = math.random(1, 80) / 100 - 0.5
		small_cube(grid, {x = x, y = -0.5, z = z}, {x = diameter, y = diameter, z = diameter})
	end

	minetest.register_node("outback:small_sandstone_rocks"..grid_count, {
		description = "Small Sandstone Rocks",
		tiles = {"default_sandstone.png"},
		is_ground_content = true,
		walkable = false,
		paramtype = "light",
		drawtype = "nodebox",
		buildable_to = true,
		node_box = {type = "fixed", fixed = grid},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {stone = 1, oddly_breakable_by_hand = 3},
		drop = "outback:small_sandstone_rocks",
		sounds = default.node_sound_stone_defaults(),
	})

	default_grid_sandstone_rocks = grid
end

minetest.register_node("outback:small_sandstone_rocks", {
	description = "Small Sandstone Rocks",
	tiles = {"default_sandstone.png"},
-- @@@ Josselin2
--	inventory_image = "ob_small_sandstone_rocks.png",
	is_ground_content = true,
	walkable = false,
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = default_grid_sandstone_rocks},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	groups = {stone = 1, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local player_name = placer:get_player_name()
		-- place a random small sandstone rocks node
		if not minetest.is_protected(pos, player_name) then
			minetest.set_node(pos, {name = "outback:small_sandstone_rocks"..math.random(1, 6)})
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
		else
			minetest.chat_send_player(player_name, "Node is protected")
			minetest.record_protection_violation(pos, player_name)
		end
		return itemstack
	end
})

-- Small stone rocks
local default_grid_stone_rocks

for grid_count = 1, 6 do
	local grid = {}
	for rock_count = 2, math.random(1, 4) + 1 do
		local diameter = math.random(15, 25) / 100
		local x = math.random(1, 80) / 100 - 0.5
		local z = math.random(1, 80) / 100 - 0.5
		small_cube(grid, {x = x, y = -0.5, z = z}, {x = diameter, y = diameter, z = diameter})
	end

	minetest.register_node("outback:small_stone_rocks"..grid_count, {
		description = "Small Stone Rocks",
		tiles = {"default_stone.png"},
		is_ground_content = true,
		walkable = false,
		paramtype = "light",
		drawtype = "nodebox",
		buildable_to = true,
		node_box = {type = "fixed", fixed = grid},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {stone = 1, oddly_breakable_by_hand = 3},
		drop = "outback:small_stone_rocks",
		sounds = default.node_sound_stone_defaults(),
	})

	default_grid_stone_rocks = grid
end

minetest.register_node("outback:small_stone_rocks", {
	description = "Small Stone Rocks",
	tiles = {"default_stone.png"},
-- @@@ Josselin2
--	inventory_image = "ob_small_stone_rocks.png",
	is_ground_content = true,
	walkable = false,
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = default_grid_stone_rocks},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
	groups = {stone = 1, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local player_name = placer:get_player_name()
		-- place a random small stone rocks node
		if not minetest.is_protected(pos, player_name) then
			minetest.set_node(pos, {name = "outback:small_stone_rocks"..math.random(1, 6)})
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
		else
			minetest.chat_send_player(player_name, "Node is protected")
			minetest.record_protection_violation(pos, player_name)
		end
		return itemstack
	end
})
