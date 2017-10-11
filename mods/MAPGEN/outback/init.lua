--[[
	Outback
--]]

-- Definitions made by this mod that other mods can use too.
outback = {}
outback.path = minetest.get_modpath("outback")


--[[
	Mapgen settings
	If you change a value here also check and, if necessary,
	change the corresponding value in voxel.lua
--]]

-- Noise parameters for biome API temperature, humidity and biome blend.
outback.mg_biome_np_heat = {offset = 50, scale = 50, seed = 5349,
	spread = {x = 1024, y = 1024, z = 1024}, octaves = 3, persist = 0.5, lacunarity = 2,}

outback.mg_biome_np_heat_blend = {offset = 0, scale = 1.5, seed = 13,
	spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1, lacunarity = 2,}

outback.mg_biome_np_humidity = {offset = 50, scale = 50, seed = 842,
	spread = {x = 1024, y = 1024, z = 1024}, octaves = 3, persist = 0.5, lacunarity = 2,}

outback.mg_biome_np_humidity_blend = {offset = 0, scale = 1.5, seed = 90003,
	spread = {x = 8, y = 8, z = 8}, octaves = 2, persist = 1, lacunarity = 2,}

-- Caves and tunnels form at the intersection of the two noises
outback.mgvalleys_np_cave1 = {offset = 0, scale = 12, seed = 52534,
	spread = {x = 61, y = 61, z = 61}, octaves = 3, persist = 0.5, lacunarity = 2,}

-- Caves and tunnels form at the intersection of the two noises
outback.mgvalleys_np_cave2 = {offset = 0, scale = 12, seed = 10325,
	spread = {x = 67, y = 67, z = 67}, octaves = 3, persist = 0.5, lacunarity = 2,}

-- The depth of dirt or other filler
outback.mgvalleys_np_filler_depth = {offset = 0, scale = 1.2, seed = 1605,
	spread = {x = 256, y = 256, z = 256}, octaves = 3, persist = 0.5, lacunarity = 2,}

-- Massive caves form here.
outback.mgvalleys_np_massive_caves = {offset = 0, scale = 1, seed = 59033,
	spread = {x = 768, y = 256, z = 768}, octaves = 6, persist = 0.63, lacunarity = 2,}

-- River noise -- rivers occur close to zero
outback.mgvalleys_np_rivers = {offset = 0, scale = 1, seed = -6050,
	spread = {x = 512, y = 512, z = 512}, octaves = 5, persist = 0.6, lacunarity = 2,}

-- Base terrain height
outback.mgvalleys_np_terrain_height = {offset = -10, scale = 100, seed = 5202,
	spread = {x = 1024, y = 1024, z = 1024}, octaves = 3, persist = 0.7, lacunarity = 2,}

-- Raises terrain to make valleys around the rivers
outback.mgvalleys_np_valley_depth = {offset = 3, scale = 2, seed = -1914,
	spread = {x = 512, y = 512, z = 512}, octaves = 1, persist = 1, lacunarity = 2,}

-- Slope and fill work together to modify the heights
outback.mgvalleys_np_inter_valley_fill = {offset = 0, scale = 1, seed = 1993,
	spread = {x = 512, y = 256, z = 512}, octaves = 6, persist = 0.8, lacunarity = 2,}

-- Amplifies the valleys
outback.mgvalleys_np_valley_profile = {offset = 0.6, scale = 0.5, seed = 777,
	spread = {x = 512, y = 512, z = 512}, octaves = 4, persist = 1, lacunarity = 2,}

-- Slope and fill work together to modify the heights
outback.mgvalleys_np_inter_valley_slope = {offset = 0, scale = 1, seed = 746,
	spread = {x = 256, y = 256, z = 256}, octaves = 3, persist = 0.5, lacunarity = 2,}

minetest.set_noiseparams("mg_biome_np_heat", outback.mg_biome_np_heat)
minetest.set_noiseparams("mg_biome_np_heat_blend", outback.mg_biome_np_heat_blend)
minetest.set_noiseparams("mg_biome_np_humidity", outback.mg_biome_np_humidity)
minetest.set_noiseparams("mg_biome_np_humidity_blend", outback.mg_biome_np_humidity_blend)
minetest.set_noiseparams("mgvalleys_np_cave1", outback.mgvalleys_np_cave1)
minetest.set_noiseparams("mgvalleys_np_cave2", outback.mgvalleys_np_cave2)
minetest.set_noiseparams("mgvalleys_np_filler_depth", outback.mgvalleys_np_filler_depth)
minetest.set_noiseparams("mgvalleys_np_massive_caves", outback.mgvalleys_np_massive_caves)
minetest.set_noiseparams("mgvalleys_np_rivers", outback.mgvalleys_np_rivers)
minetest.set_noiseparams("mgvalleys_np_terrain_height", outback.mgvalleys_np_terrain_height)
minetest.set_noiseparams("mgvalleys_np_valley_depth", outback.mgvalleys_np_valley_depth)
minetest.set_noiseparams("mgvalleys_np_inter_valley_fill", outback.mgvalleys_np_inter_valley_fill)
minetest.set_noiseparams("mgvalleys_np_valley_profile", outback.mgvalleys_np_valley_profile)
minetest.set_noiseparams("mgvalleys_np_inter_valley_slope", outback.mgvalleys_np_inter_valley_slope)

-- How deep to make rivers
minetest.setting_set("mgvalleys_river_depth", 5)

-- How wide to make rivers
minetest.setting_set("mgvalleys_river_size", 4)


--[[
	Load files
--]]

dofile(outback.path .. "/functions.lua")
dofile(outback.path .. "/voxel.lua")
