--[[
	Furnace
--]]

local furnace = {}

--[[
	Formspecs
--]]

local function active_formspec(fuel_percent, item_percent)
	local formspec =
		"size[8,8.5]"..
		init.gui_bg..
		init.gui_bg_img..
		init.gui_slots..
		"list[current_name;src;2.75,0.5;1,1;]"..
		"list[current_name;fuel;2.75,2.5;1,1;]"..
		"image[2.75,1.5;1,1;furnace_furnace_fire_bg.png^[lowpart:"..
		(100-fuel_percent)..":furnace_furnace_fire_fg.png]"..
		"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[lowpart:"..
		(item_percent)..":gui_furnace_arrow_fg.png^[transformR270]"..
		"list[current_name;dst;4.75,0.96;2,2;]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[current_name;dst]"..
		"listring[current_player;main]"..
		"listring[current_name;src]"..
		"listring[current_player;main]"..
		"listring[current_name;fuel]"..
		"listring[current_player;main]"..
		init.get_hotbar_bg(0, 4.25)
	return formspec
end

local inactive_formspec =
	"size[8,8.5]"..
	init.gui_bg..
	init.gui_bg_img..
	init.gui_slots..
	"list[current_name;src;2.75,0.5;1,1;]"..
	"list[current_name;fuel;2.75,2.5;1,1;]"..
	"image[2.75,1.5;1,1;furnace_furnace_fire_bg.png]"..
	"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_name;dst;4.75,0.96;2,2;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"listring[current_name;dst]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	"listring[current_name;fuel]"..
	"listring[current_player;main]"..
	init.get_hotbar_bg(0, 4.25)


--[[
	Node callback functions that are the same for active and inactive furnace
--]]

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("fuel") and inv:is_empty("dst") and inv:is_empty("src")
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			if inv:is_empty("src") then
				meta:set_string("infotext", "Furnace is empty")
			end
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function furnace_node_timer(pos, elapsed)
	-- Inizialize metadata
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local srclist, fuellist

	local cookable, cooked
	local fuel

	local update = true
	while update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")

		--[[
			Cooking
		--]]

		-- Check if we have cookable content
		local aftercooked
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cookable = cooked.time ~= 0

		-- Check if we have enough fuel to burn
		if fuel_time < fuel_totaltime then
			-- The furnace is currently active and has enough fuel
			fuel_time = fuel_time + elapsed
			-- If there is a cookable item then check if it is ready yet
			if cookable then
				src_time = src_time + elapsed
				if src_time >= cooked.time then
					-- Place result in dst list if possible
					if inv:room_for_item("dst", cooked.item) then
						inv:add_item("dst", cooked.item)
						inv:set_stack("src", 1, aftercooked.items[1])
						src_time = src_time - cooked.time
						update = true
					end
				end
			end
		else
			-- Furnace ran out of fuel
			if cookable then
				-- We need to get new fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

				if fuel.time == 0 then
					-- No valid fuel in fuel list
					fuel_totaltime = 0
					src_time = 0
				else
					-- Take fuel from fuel list
					inv:set_stack("fuel", 1, afterfuel.items[1])
					update = true
					fuel_totaltime = fuel.time + (fuel_time - fuel_totaltime)
					src_time = src_time + elapsed
				end
			else
				-- We don't need to get new fuel since there is no cookable item
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = 0
	end

	if fuel and fuel_totaltime > fuel.time then
		fuel_totaltime = fuel.time
	end
	if srclist[1]:is_empty() then
		src_time = 0
	end

	--[[
		Update formspec, infotext and node
	--]]
	local formspec = inactive_formspec
	local item_state
	local item_percent = 0
	if cookable then
		item_percent = math.floor(src_time / cooked.time * 100)
		if item_percent > 100 then
			item_state = "100% (output full)"
		else
			item_state = item_percent .. "%"
		end
	else
		if srclist[1]:is_empty() then
			item_state = "Empty"
		else
			item_state = "Not cookable"
		end
	end

	local fuel_state = "Empty"
	local active = "inactive "
	local result = false

	if fuel_totaltime ~= 0 then
		active = "active "
		local fuel_percent = math.floor(fuel_time / fuel_totaltime * 100)
		fuel_state = fuel_percent .. "%"
		formspec = active_formspec(fuel_percent, item_percent)
		swap_node(pos, "furnace:furnace_active")
		-- make sure timer restarts automatically
		result = true
	else
		if not fuellist[1]:is_empty() then
			fuel_state = "0%"
		end
		swap_node(pos, "furnace:furnace")
		-- stop timer on the inactive furnace
		minetest.get_node_timer(pos):stop()
	end

	local infotext = "Furnace " .. active .. "(Item: " .. item_state .. "; Fuel: " .. fuel_state .. ")"

	-- Set meta values
	meta:set_float("fuel_totaltime", fuel_totaltime)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)
	meta:set_string("formspec", formspec)
	meta:set_string("infotext", infotext)

	return result
end


--[[
	Node definitions
--]]

minetest.register_node("furnace:furnace", {
	description = "Furnace",
	tiles = {
		"furnace_furnace_top.png", "furnace_furnace_bottom.png",
		"furnace_furnace_side.png", "furnace_furnace_side.png",
		"furnace_furnace_side.png", "furnace_furnace_front.png"
	},
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = base.node_sound_stone_defaults(),

	can_dig = can_dig,

	on_timer = furnace_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", inactive_formspec)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('fuel', 1)
		inv:set_size('dst', 4)
	end,

	on_metadata_inventory_move = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
		base.get_inventory_drops(pos, "src", drops)
		base.get_inventory_drops(pos, "fuel", drops)
		base.get_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "furnace:furnace"
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("furnace:furnace_active", {
	description = "Furnace",
	tiles = {
		"furnace_furnace_top.png", "furnace_furnace_bottom.png",
		"furnace_furnace_side.png", "furnace_furnace_side.png",
		"furnace_furnace_side.png",
		{
			image = "furnace_furnace_front_active.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5
			},
		}
	},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "furnace:furnace",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = base.node_sound_stone_defaults(),
	on_timer = furnace_node_timer,

	can_dig = can_dig,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_craft({
	output = 'furnace:furnace',
	recipe = {
		{'group:stone', 'group:stone', 'group:stone'},
		{'group:stone', '', 'group:stone'},
		{'group:stone', 'group:stone', 'group:stone'},
	}
})



--[[
	Tree (trunks) fuel
--]]

local function add_tree_fuel(name, burntime)
	minetest.register_craft({
		type = "fuel",
		recipe = "base:" .. name,
		burntime = burntime,
	})
end

furnace.tree_fuel = {
	{"aspen_tree", 22},
	{"pine_tree", 26},
	{"huon_pine_tree", 26},
	{"celery_top_pine_tree", 26},
	{"southern_sassafras_tree", 26},
	{"tree", 30},
	{"tasmanian_myrtle_tree", 31},
	{"swamp_gum_tree", 32},
	{"acacia_tree", 34},
	{"marri_tree", 34},
	{"black_wattle_tree", 35},
	{"merbau_tree", 36},
	{"jarrah_tree", 37},
	{"blue_gum_tree", 37},
	{"karri_tree", 37},
	{"jungletree", 38},
	{"river_red_gum_tree", 38},
	{"daintree_stringybark_tree", 40},
}

for _,item in pairs(furnace.tree_fuel) do
	add_tree_fuel(unpack(item))
end

-- Support use of group:tree
minetest.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 25,
})


--[[
	Wood (planks) fuel
--]]

local function add_wood_fuel(name, burntime)
	minetest.register_craft({
		type = "fuel",
		recipe = "base:" .. name,
		burntime = burntime,
	})
end

furnace.wood_fuel = {
	{"aspen_wood", 5},
	{"pine_wood", 6},
	{"eucalyptus_wood", 6},
	{"huon_pine", 6},
	{"celery_top_pine", 6},
	{"southern_sassafras", 6},
	{"wood", 7},
	{"tasmanian_myrtle", 7},
	{"tasmanian_oak", 7},
	{"acacia_wood", 8},
	{"marri", 8},
	{"blackwood", 8},
	{"merbau", 8},
	{"jarrah", 8},
	{"blue_gum", 8},
	{"karri", 8},
	{"junglewood", 9},
	{"river_red_gum", 9},
	{"red_mahogany", 10},
}

for _,item in pairs(furnace.wood_fuel) do
	add_wood_fuel(unpack(item))
end

-- Support use of group:wood
minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 6,
})


--[[
	Sapling fuel
--]]

local function add_sapling_fuel(name, burntime)
	minetest.register_craft({
		type = "fuel",
		recipe = "base:" .. name,
		burntime = burntime,
	})
end

furnace.sapling_fuel = {
	{"bush_sapling", 6},
	{"acacia_bush_sapling", 7},
	{"aspen_sapling", 8},
	{"pine_sapling", 9},
	{"eucalyptus_sapling", 9},
	{"huon_pine_sapling", 9},
	{"celery_top_pine_sapling", 9},
	{"southern_sassafras_sapling", 9},
	{"sapling", 10},
	{"tasmanian_myrtle_sapling", 10},
	{"swamp_gum_sapling", 10},
	{"acacia_sapling", 11},
	{"marri_sapling", 11},
	{"black_wattle_sapling", 11},
	{"merbau_sapling", 11},
	{"jarrah_sapling", 11},
	{"blue_gum_sapling", 11},
	{"karri_sapling", 11},
	{"junglesapling", 12},
	{"river_red_gum_sapling", 12},
	{"daintree_stringybark_sapling", 14},
}

for _,item in pairs(furnace.sapling_fuel) do
	add_sapling_fuel(unpack(item))
end

-- Support use of group:sapling
minetest.register_craft({
	type = "fuel",
	recipe = "group:sapling",
	burntime = 9,
})


--[[
	Fence fuel
--]]

local function add_fence_fuel(name, burntime)
	minetest.register_craft({
		type = "fuel",
		recipe = "fences:" .. name,
		burntime = burntime,
	})
end

furnace.fence_fuel = {
	{"fence_aspen_wood", 5},
	{"fence_pine_wood", 6},
	{"fence_eucalyptus_wood", 6},
	{"fence_huon_pine", 6},
	{"fence_celery_top_pine", 6},
	{"fence_southern_sassafras", 6},
	{"fence_wood", 7},
	{"fence_tasmanian_myrtle", 7},
	{"fence_tasmanian_oak", 7},
	{"fence_acacia_wood", 8},
	{"fence_marri", 8},
	{"fence_blackwood", 8},
	{"fence_merbau", 8},
	{"fence_jarrah", 8},
	{"fence_blue_gum", 8},
	{"fence_karri", 8},
	{"fence_junglewood", 9},
	{"fence_red_gum", 9},
	{"fence_red_mahogany", 10},
}

for _,item in pairs(furnace.fence_fuel) do
	add_fence_fuel(unpack(item))
end


minetest.register_craft({
	type = "fuel",
	recipe = "base:bush_stem",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:acacia_bush_stem",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:junglegrass",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:cactus",
	burntime = 15,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:papyrus",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:ladder_wood",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:lava_source",
	burntime = 60,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:apple",
	burntime = 3,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:coal_lump",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:coalblock",
	burntime = 370,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:grass_1",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:dry_grass_1",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:paper",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "base:dry_shrub",
	burntime = 2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:stick",
	burntime = 1,
})

