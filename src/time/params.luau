local krnl = require("../../roblox_packages/jecs_kernel")
local jecs = require("../../roblox_packages/jecs")

local luau_time = require("../../roblox_packages/luau_time")

local resources = require("./resources")

local mod = {}

local RealTime = (
	(
		krnl.param<<luau_time.Time, nil>>(function(world: jecs.World)
			local time = world:get(resources.RealTime, resources.RealTime)
			if not time then return false, nil :: any end
			return true, time
		end, function()
			return nil
		end)
	) :: any
) :: luau_time.Time

local FixedTime = (
	(
		krnl.param<<luau_time.Time, nil>>(function(world: jecs.World)
			local time = world:get(resources.FixedTime, resources.FixedTime)
			if not time then return false, nil :: any end
			return true, time
		end, function()
			return nil
		end)
	) :: any
) :: luau_time.Time

mod.RealTime = RealTime
mod.FixedTime = FixedTime

return mod
