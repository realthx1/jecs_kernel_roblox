--!native
--!optimize 2

local krnl = require("../../roblox_packages/jecs_kernel")
local jecs = require("../../roblox_packages/jecs")

local resources = require("./resources")

local mod = {}

local function advance_fixed_time(world: jecs.World, delta: number)
	local old_time = world:get(resources.FixedTime, resources.FixedTime)
	assert(
		old_time,
		"A custom jecs world was created before jecs_kernel_roblox was imported! Ensure that the package gets imported before you create a custom world."
	)

	old_time:advance_by(delta)
	world:set(resources.FixedTime, resources.FixedTime, old_time)
end

local advance_time_sys = krnl.sys("advance_time_sys", krnl.std_params.World)(function(world: jecs.World)
	local old_real_time = world:get(resources.RealTime, resources.RealTime)
	local old_sync_time = world:get(resources.SyncTime, resources.SyncTime)
	assert(
		old_sync_time and old_real_time,
		"A custom jecs world was created before jecs_kernel_roblox was imported! Ensure that the package gets imported before you create a custom world."
	)

	old_real_time:advance_to(os.clock())
	old_sync_time:advance_to(workspace:GetServerTimeNow())

	world:set(resources.SyncTime, resources.SyncTime, old_sync_time)
	world:set(resources.RealTime, resources.RealTime, old_real_time)
end)

mod.advance_fixed_time = advance_fixed_time
mod.advance_time_sys = advance_time_sys

return mod
