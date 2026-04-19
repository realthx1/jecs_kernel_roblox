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

local advance_real_time_sys = krnl.sys("advance_real_time_sys", krnl.std.system_params.World)(
	function(world: jecs.World)
		local old_time = world:get(resources.RealTime, resources.RealTime)
		assert(
			old_time,
			"A custom jecs world was created before jecs_kernel_roblox was imported! Ensure that the package gets imported before you create a custom world."
		)

		old_time:advance_to(os.clock())
		world:set(resources.RealTime, resources.RealTime, old_time)
	end
)

mod.advance_fixed_time = advance_fixed_time
mod.advance_real_time_sys = advance_real_time_sys

return mod
