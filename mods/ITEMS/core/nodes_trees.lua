--[[
	Core tree nodes
--]]


minetest.register_node("core:tree", {
	description = "Tree",
	tiles = {"core_tree_top.png", "core_tree_top.png", "core_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = core.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("core:wood", {
	description = "Wooden Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"core_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = core.node_sound_wood_defaults(),
})

minetest.register_node("core:sapling", {
	description = "Sapling",
	drawtype = "plantlike",
	tiles = {"core_sapling.png"},
	inventory_image = "core_sapling.png",
	wield_image = "core_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = core.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = core.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = core.sapling_on_place(itemstack, placer, pointed_thing,
			"core:sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 6, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

minetest.register_node("core:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"core_leaves.png"},
	special_tiles = {"core_leaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'core:sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'core:leaves'},
			}
		}
	},
	sounds = core.node_sound_leaves_defaults(),

	after_place_node = core.after_place_leaves,
})

minetest.register_node("core:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"core_apple.png"},
	inventory_image = "core_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1},
	on_use = minetest.item_eat(2),
	sounds = core.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name = "core:apple", param2 = 1})
		end
	end,
})


minetest.register_node("core:jungletree", {
	description = "Jungle Tree",
	tiles = {"core_jungletree_top.png", "core_jungletree_top.png",
		"core_jungletree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = core.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("core:junglewood", {
	description = "Jungle Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"core_junglewood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = core.node_sound_wood_defaults(),
})

minetest.register_node("core:jungleleaves", {
	description = "Jungle Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"core_jungleleaves.png"},
	special_tiles = {"core_jungleleaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {'core:junglesapling'}, rarity = 20},
			{items = {'core:jungleleaves'}}
		}
	},
	sounds = core.node_sound_leaves_defaults(),

	after_place_node = core.after_place_leaves,
})

minetest.register_node("core:junglesapling", {
	description = "Jungle Sapling",
	drawtype = "plantlike",
	tiles = {"core_junglesapling.png"},
	inventory_image = "core_junglesapling.png",
	wield_image = "core_junglesapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = core.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = core.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = core.sapling_on_place(itemstack, placer, pointed_thing,
			"core:junglesapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 15, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})


minetest.register_node("core:pine_tree", {
	description = "Pine Tree",
	tiles = {"core_pine_tree_top.png", "core_pine_tree_top.png",
		"core_pine_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = core.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("core:pine_wood", {
	description = "Pine Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"core_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = core.node_sound_wood_defaults(),
})

minetest.register_node("core:pine_needles",{
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	tiles = {"core_pine_needles.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"core:pine_sapling"}, rarity = 20},
			{items = {"core:pine_needles"}}
		}
	},
	sounds = core.node_sound_leaves_defaults(),

	after_place_node = core.after_place_leaves,
})

minetest.register_node("core:pine_sapling", {
	description = "Pine Sapling",
	drawtype = "plantlike",
	tiles = {"core_pine_sapling.png"},
	inventory_image = "core_pine_sapling.png",
	wield_image = "core_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = core.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = core.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = core.sapling_on_place(itemstack, placer, pointed_thing,
			"core:pine_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 12, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})


minetest.register_node("core:acacia_tree", {
	description = "Acacia Tree",
	tiles = {"core_acacia_tree_top.png", "core_acacia_tree_top.png",
		"core_acacia_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = core.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("core:acacia_wood", {
	description = "Acacia Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"core_acacia_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = core.node_sound_wood_defaults(),
})

minetest.register_node("core:acacia_leaves", {
	description = "Acacia Leaves",
	drawtype = "allfaces_optional",
	tiles = {"core_acacia_leaves.png"},
	special_tiles = {"core_acacia_leaves_simple.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"core:acacia_sapling"}, rarity = 20},
			{items = {"core:acacia_leaves"}}
		}
	},
	sounds = core.node_sound_leaves_defaults(),

	after_place_node = core.after_place_leaves,
})

minetest.register_node("core:acacia_sapling", {
	description = "Acacia Tree Sapling",
	drawtype = "plantlike",
	tiles = {"core_acacia_sapling.png"},
	inventory_image = "core_acacia_sapling.png",
	wield_image = "core_acacia_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = core.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = core.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = core.sapling_on_place(itemstack, placer, pointed_thing,
			"core:acacia_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -4, y = 1, z = -4},
			{x = 4, y = 6, z = 4},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

minetest.register_node("core:aspen_tree", {
	description = "Aspen Tree",
	tiles = {"core_aspen_tree_top.png", "core_aspen_tree_top.png",
		"core_aspen_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = core.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("core:aspen_wood", {
	description = "Aspen Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"core_aspen_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = core.node_sound_wood_defaults(),
})

minetest.register_node("core:aspen_leaves", {
	description = "Aspen Leaves",
	drawtype = "allfaces_optional",
	tiles = {"core_aspen_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"core:aspen_sapling"}, rarity = 20},
			{items = {"core:aspen_leaves"}}
		}
	},
	sounds = core.node_sound_leaves_defaults(),

	after_place_node = core.after_place_leaves,
})

minetest.register_node("core:aspen_sapling", {
	description = "Aspen Tree Sapling",
	drawtype = "plantlike",
	tiles = {"core_aspen_sapling.png"},
	inventory_image = "core_aspen_sapling.png",
	wield_image = "core_aspen_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = core.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 0.5, 3 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = core.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = core.sapling_on_place(itemstack, placer, pointed_thing,
			"core:aspen_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 12, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})


local random = math.random

--
-- Grow trees from saplings
--

-- 'can grow' function

function core.can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "soil")
	if is_soil == 0 then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end


-- 'is snow nearby' function

local function is_snow_nearby(pos)
	return minetest.find_node_near(pos, 1, {"group:snowy"})
end


-- Sapling ABM

function core.grow_sapling(pos)
	if not core.can_grow(pos) then
		-- try a bit later again
		minetest.get_node_timer(pos):start(math.random(240, 600))
		return
	end

	local mg_name = minetest.get_mapgen_setting("mg_name")
	local node = minetest.get_node(pos)
	if node.name == "core:sapling" then
		minetest.log("action", "A sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		if mg_name == "v6" then
			core.grow_tree(pos, random(1, 4) == 1)
		else
			core.grow_new_apple_tree(pos)
		end
	elseif node.name == "core:junglesapling" then
		minetest.log("action", "A jungle sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		if mg_name == "v6" then
			core.grow_jungle_tree(pos)
		else
			core.grow_new_jungle_tree(pos)
		end
	elseif node.name == "core:pine_sapling" then
		minetest.log("action", "A pine sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		local snow = is_snow_nearby(pos)
		if mg_name == "v6" then
			core.grow_pine_tree(pos, snow)
		elseif snow then
			core.grow_new_snowy_pine_tree(pos)
		else
			core.grow_new_pine_tree(pos)
		end
	elseif node.name == "core:acacia_sapling" then
		minetest.log("action", "An acacia sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		core.grow_new_acacia_tree(pos)
	elseif node.name == "core:aspen_sapling" then
		minetest.log("action", "An aspen sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		core.grow_new_aspen_tree(pos)
	elseif node.name == "core:bush_sapling" then
		minetest.log("action", "A bush sapling grows into a bush at "..
			minetest.pos_to_string(pos))
		core.grow_bush(pos)
	elseif node.name == "core:acacia_bush_sapling" then
		minetest.log("action", "An acacia bush sapling grows into a bush at "..
			minetest.pos_to_string(pos))
		core.grow_acacia_bush(pos)
	end
end

minetest.register_lbm({
	name = "core:convert_saplings_to_node_timer",
	nodenames = {"core:sapling", "core:junglesapling",
			"core:pine_sapling", "core:acacia_sapling",
			"core:aspen_sapling"},
	action = function(pos)
		minetest.get_node_timer(pos):start(math.random(1200, 2400))
	end
})

--
-- Tree generation
--

-- Apple tree and jungle tree trunk and leaves function

local function add_trunk_and_leaves(data, a, pos, tree_cid, leaves_cid,
		height, size, iters, is_apple_tree)
	local x, y, z = pos.x, pos.y, pos.z
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_apple = minetest.get_content_id("core:apple")

	-- Trunk
	data[a:index(x, y, z)] = tree_cid -- Force-place lowest trunk node to replace sapling
	for yy = y + 1, y + height - 1 do
		local vi = a:index(x, yy, z)
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore or node_id == leaves_cid then
			data[vi] = tree_cid
		end
	end

	-- Force leaves near the trunk
	for z_dist = -1, 1 do
	for y_dist = -size, 1 do
		local vi = a:index(x - 1, y + height + y_dist, z + z_dist)
		for x_dist = -1, 1 do
			if data[vi] == c_air or data[vi] == c_ignore then
				if is_apple_tree and random(1, 8) == 1 then
					data[vi] = c_apple
				else
					data[vi] = leaves_cid
				end
			end
			vi = vi + 1
		end
	end
	end

	-- Randomly add leaves in 2x2x2 clusters.
	for i = 1, iters do
		local clust_x = x + random(-size, size - 1)
		local clust_y = y + height + random(-size, 0)
		local clust_z = z + random(-size, size - 1)

		for xi = 0, 1 do
		for yi = 0, 1 do
		for zi = 0, 1 do
			local vi = a:index(clust_x + xi, clust_y + yi, clust_z + zi)
			if data[vi] == c_air or data[vi] == c_ignore then
				if is_apple_tree and random(1, 8) == 1 then
					data[vi] = c_apple
				else
					data[vi] = leaves_cid
				end
			end
		end
		end
		end
	end
end


-- Apple tree

function core.grow_tree(pos, is_apple_tree, bad)
	--[[
		NOTE: Tree-placing code is currently duplicated in the engine
		and in games that have saplings; both are deprecated but not
		replaced yet
	--]]
	if bad then
		error("Deprecated use of core.grow_tree")
	end

	local x, y, z = pos.x, pos.y, pos.z
	local height = random(4, 5)
	local c_tree = minetest.get_content_id("core:tree")
	local c_leaves = minetest.get_content_id("core:leaves")

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 2, y = y, z = z - 2},
		{x = x + 2, y = y + height + 1, z = z + 2}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	add_trunk_and_leaves(data, a, pos, c_tree, c_leaves, height, 2, 8, is_apple_tree)

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end


-- Jungle tree

function core.grow_jungle_tree(pos, bad)
	--[[
		NOTE: Jungletree-placing code is currently duplicated in the engine
		and in games that have saplings; both are deprecated but not
		replaced yet
	--]]
	if bad then
		error("Deprecated use of core.grow_jungle_tree")
	end

	local x, y, z = pos.x, pos.y, pos.z
	local height = random(8, 12)
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_jungletree = minetest.get_content_id("core:jungletree")
	local c_jungleleaves = minetest.get_content_id("core:jungleleaves")

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 3, y = y - 1, z = z - 3},
		{x = x + 3, y = y + height + 1, z = z + 3}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	add_trunk_and_leaves(data, a, pos, c_jungletree, c_jungleleaves,
		height, 3, 30, false)

	-- Roots
	for z_dist = -1, 1 do
		local vi_1 = a:index(x - 1, y - 1, z + z_dist)
		local vi_2 = a:index(x - 1, y, z + z_dist)
		for x_dist = -1, 1 do
			if random(1, 3) >= 2 then
				if data[vi_1] == c_air or data[vi_1] == c_ignore then
					data[vi_1] = c_jungletree
				elseif data[vi_2] == c_air or data[vi_2] == c_ignore then
					data[vi_2] = c_jungletree
				end
			end
			vi_1 = vi_1 + 1
			vi_2 = vi_2 + 1
		end
	end

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end


-- Pine tree from mg mapgen mod, design by sfan5, pointy top added by paramat

local function add_pine_needles(data, vi, c_air, c_ignore, c_snow, c_pine_needles)
	local node_id = data[vi]
	if node_id == c_air or node_id == c_ignore or node_id == c_snow then
		data[vi] = c_pine_needles
	end
end

local function add_snow(data, vi, c_air, c_ignore, c_snow)
	local node_id = data[vi]
	if node_id == c_air or node_id == c_ignore then
		data[vi] = c_snow
	end
end

function core.grow_pine_tree(pos, snow)
	local x, y, z = pos.x, pos.y, pos.z
	local maxy = y + random(9, 13) -- Trunk top

	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_pine_tree = minetest.get_content_id("core:pine_tree")
	local c_pine_needles  = minetest.get_content_id("core:pine_needles")
	local c_snow = minetest.get_content_id("core:snow")

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 3, y = y, z = z - 3},
		{x = x + 3, y = maxy + 3, z = z + 3}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	-- Upper branches layer
	local dev = 3
	for yy = maxy - 1, maxy + 1 do
		for zz = z - dev, z + dev do
			local vi = a:index(x - dev, yy, zz)
			local via = a:index(x - dev, yy + 1, zz)
			for xx = x - dev, x + dev do
				if random() < 0.95 - dev * 0.05 then
					add_pine_needles(data, vi, c_air, c_ignore, c_snow,
						c_pine_needles)
					if snow then
						add_snow(data, via, c_air, c_ignore, c_snow)
					end
				end
				vi  = vi + 1
				via = via + 1
			end
		end
		dev = dev - 1
	end

	-- Centre top nodes
	add_pine_needles(data, a:index(x, maxy + 1, z), c_air, c_ignore, c_snow,
		c_pine_needles)
	add_pine_needles(data, a:index(x, maxy + 2, z), c_air, c_ignore, c_snow,
		c_pine_needles) -- Paramat added a pointy top node
	if snow then
		add_snow(data, a:index(x, maxy + 3, z), c_air, c_ignore, c_snow)
	end

	-- Lower branches layer
	local my = 0
	for i = 1, 20 do -- Random 2x2 squares of needles
		local xi = x + random(-3, 2)
		local yy = maxy + random(-6, -5)
		local zi = z + random(-3, 2)
		if yy > my then
			my = yy
		end
		for zz = zi, zi+1 do
			local vi = a:index(xi, yy, zz)
			local via = a:index(xi, yy + 1, zz)
			for xx = xi, xi + 1 do
				add_pine_needles(data, vi, c_air, c_ignore, c_snow,
					c_pine_needles)
				if snow then
					add_snow(data, via, c_air, c_ignore, c_snow)
				end
				vi  = vi + 1
				via = via + 1
			end
		end
	end

	dev = 2
	for yy = my + 1, my + 2 do
		for zz = z - dev, z + dev do
			local vi = a:index(x - dev, yy, zz)
			local via = a:index(x - dev, yy + 1, zz)
			for xx = x - dev, x + dev do
				if random() < 0.95 - dev * 0.05 then
					add_pine_needles(data, vi, c_air, c_ignore, c_snow,
						c_pine_needles)
					if snow then
						add_snow(data, via, c_air, c_ignore, c_snow)
					end
				end
				vi  = vi + 1
				via = via + 1
			end
		end
		dev = dev - 1
	end

	-- Trunk
	-- Force-place lowest trunk node to replace sapling
	data[a:index(x, y, z)] = c_pine_tree
	for yy = y + 1, maxy do
		local vi = a:index(x, yy, z)
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore or
				node_id == c_pine_needles or node_id == c_snow then
			data[vi] = c_pine_tree
		end
	end

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end


-- Aliases for schematic nodes
minetest.register_alias("default:tree", "core:tree")
minetest.register_alias("default:leaves", "core:leaves")
minetest.register_alias("default:apple", "core:apple")
minetest.register_alias("default:jungletree", "core:jungletree")
minetest.register_alias("default:jungleleaves", "core:jungleleaves")
minetest.register_alias("default:pine_tree", "core:pine_tree")
minetest.register_alias("default:pine_leaves", "core:pine_leaves")
minetest.register_alias("default:acacia_tree", "core:acacia_tree")
minetest.register_alias("default:acacia_leaves", "core:acacia_leaves")
minetest.register_alias("default:aspen_tree", "core:aspen_tree")
minetest.register_alias("default:aspen_leaves", "core:aspen_leaves")


-- New apple tree

function core.grow_new_apple_tree(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/apple_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
		path, "random", nil, false)
end


-- New jungle tree

function core.grow_new_jungle_tree(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/jungle_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
		path, "random", nil, false)
end


-- New pine tree

function core.grow_new_pine_tree(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/pine_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
		path, "0", nil, false)
end


-- New snowy pine tree

function core.grow_new_snowy_pine_tree(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/snowy_pine_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
		path, "random", nil, false)
end


-- New acacia tree

function core.grow_new_acacia_tree(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/acacia_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 4, y = pos.y - 1, z = pos.z - 4},
		path, "random", nil, false)
end


-- New aspen tree

function core.grow_new_aspen_tree(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/aspen_tree_from_sapling.mts"
	minetest.place_schematic({x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
		path, "0", nil, false)
end


-- Bushes do not need 'from sapling' schematic variants because
-- only the stem node is force-placed in the schematic.

-- Bush

function core.grow_bush(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/bush.mts"
	minetest.place_schematic({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
		path, "0", nil, false)
end


-- Acacia bush

function core.grow_acacia_bush(pos)
	local path = minetest.get_modpath("core") ..
		"/schematics/acacia_bush.mts"
	minetest.place_schematic({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
		path, "0", nil, false)
end


--
-- Sapling 'on place' function to check protection of node and resulting tree volume
--

function core.sapling_on_place(itemstack, placer, pointed_thing,
		sapling_name, minp_relative, maxp_relative, interval)
	-- Position of sapling
	local pos = pointed_thing.under
	local node = minetest.get_node_or_nil(pos)
	local pdef = node and minetest.registered_nodes[node.name]

	if pdef and pdef.on_rightclick and not placer:get_player_control().sneak then
		return pdef.on_rightclick(pos, node, placer, itemstack, pointed_thing)
	end

	if not pdef or not pdef.buildable_to then
		pos = pointed_thing.above
		node = minetest.get_node_or_nil(pos)
		pdef = node and minetest.registered_nodes[node.name]
		if not pdef or not pdef.buildable_to then
			return itemstack
		end
	end

	local player_name = placer:get_player_name()
	-- Check sapling position for protection
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return itemstack
	end
	-- Check tree volume for protection
	if core.intersects_protection(
			vector.add(pos, minp_relative),
			vector.add(pos, maxp_relative),
			player_name,
			interval) then
		minetest.record_protection_violation(pos, player_name)
		-- Print extra information to explain
		minetest.chat_send_player(player_name, "Tree will intersect protection")
		return itemstack
	end

	minetest.log("action", player_name .. " places node "
			.. sapling_name .. " at " .. minetest.pos_to_string(pos))

	local take_item = not (creative and creative.is_enabled_for
		and creative.is_enabled_for(player_name))
	local newnode = {name = sapling_name}
	local ndef = minetest.registered_nodes[sapling_name]
	minetest.set_node(pos, newnode)

	-- Run callback
	if ndef and ndef.after_place_node then
		-- Deepcopy place_to and pointed_thing because callback can modify it
		if ndef.after_place_node(table.copy(pos), placer,
				itemstack, table.copy(pointed_thing)) then
			take_item = false
		end
	end

	-- Run script hook
	for _, callback in ipairs(minetest.registered_on_placenodes) do
		-- Deepcopy pos, node and pointed_thing because callback can modify them
		if callback(table.copy(pos), table.copy(newnode),
				placer, table.copy(node or {}),
				itemstack, table.copy(pointed_thing)) then
			take_item = false
		end
	end

	if take_item then
		itemstack:take_item()
	end

	return itemstack
end


--
-- register trees for leafdecay
--

core.register_leafdecay({
	trunks = {"core:tree"},
	leaves = {"core:apple", "core:leaves"},
	radius = 3,
})

core.register_leafdecay({
	trunks = {"core:jungletree"},
	leaves = {"core:jungleleaves"},
	radius = 2,
})

core.register_leafdecay({
	trunks = {"core:pine_tree"},
	leaves = {"core:pine_needles"},
	radius = 2,
})

core.register_leafdecay({
	trunks = {"core:acacia_tree"},
	leaves = {"core:acacia_leaves"},
	radius = 2,
})

core.register_leafdecay({
	trunks = {"core:aspen_tree"},
	leaves = {"core:aspen_leaves"},
	radius = 3,
})

core.register_leafdecay({
	trunks = {"core:bush_stem"},
	leaves = {"core:bush_leaves"},
	radius = 1,
})

core.register_leafdecay({
	trunks = {"core:acacia_bush_stem"},
	leaves = {"core:acacia_bush_leaves"},
	radius = 1,
})
