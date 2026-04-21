--[[
    Jecs_kernel_roblox adds utilities to track time via clocks.
    This example showcases how to interact with time resources.
]]

local krnl = require("@pkg/jecs_kernel")
local jecs = require("@pkg/jecs")
local krnl_roblox = require("@krnl_roblox")
local luau_time = require("@pkg/luau_time")

local schedules = krnl_roblox.schedules

local human_tag = jecs.tag()
local Position = jecs.component<<vector>>()
local Velocity = jecs.component<<vector>>()

local human_add_sys = krnl.sys("human_add", krnl.std_params.World)(function(world: jecs.World)
	for i = 1, 10 do
		local human_ent = world:entity()
		world:add(human_ent, human_tag)
		world:set(
			human_ent,
			Position,
			vector.create(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
		)
		world:set(
			human_ent,
			Velocity,
			vector.create(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
		)
	end
end)

local human_move_sys = krnl.sys(
	"human_move",
	krnl.std_params.World,
	krnl.std_params.Res(krnl_roblox.time.FixedTime) -- time can be acquired using SystemParams `FixedTime` and `RealTime`
	-- FixedTime should be used in systems that will run in fixed schedules
)(function(world: jecs.World, time: luau_time.Time)
	local delta = time:delta() -- delta in FixedTime is always 64hz
	for human_ent, position_vec, velocity_vec in world:query(Position, Velocity):with(human_tag) do
		world:set(human_ent, Position, position_vec + velocity_vec * delta)
	end
end)

local human_out_of_bounds_sys = krnl.sys("human_out_of_bounds", krnl.std_params.World)(function(world: jecs.World)
	for human_ent, position_vec in world:query(Position):with(human_tag) do
		if vector.magnitude(position_vec) > 1000 then
			print(human_ent, "is out of bounds, deleting")
			world:delete(human_ent)
		end
	end
end)

local time_print_sys = krnl.sys(
	"time_print",
	krnl.std_params.Res(krnl_roblox.time.RealTime) -- `RealTime` follows `os.clock()` time
)(function(time: luau_time.Time)
	print((time:elapsed() // 1) .. " seconds")
end)

krnl
	.new_app()
	:add_plugin_group(krnl_roblox.DefaultPlugins) -- DefaultPlugins contains essential plugins for Roblox and the package itself
	:add_systems(schedules.Startup.Startup, { human_add_sys })
	:add_systems(schedules.FixedMain.FixedUpdate, { human_move_sys })
	:add_systems(schedules.Main.Update, {
		time_print_sys:run_if({ krnl.std_conditions.interval(1) }),
		human_out_of_bounds_sys:run_if({ krnl.std_conditions.interval(1) }),
	})
	:run(krnl_roblox.app_runner) -- the default runner runs all default schedules
