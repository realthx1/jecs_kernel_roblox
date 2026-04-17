--!optimize 2
--!native

local runservice = game:GetService("RunService")

local krnl = require("./roblox_packages/jecs_kernel")

local default_plugins_mod = require("@self/default_plugins")
local schedules_mod = require("@self/schedules")
local fixedstep_mod = require("@self/fixedstep")
local schedules_plugin_mod = require("@self/schedules_plugin")

--[=[
    Collection of utilities for the jecs_kernel framework and Roblox.
]=]
local mod = {}

local function default_app_runner(app: krnl.App): (boolean, string)
	schedules_mod.startup_pipeline[1]:run(app.world)
	schedules_mod.startup_pipeline[2]:run(app.world)
	schedules_mod.startup_pipeline[3]:run(app.world)

	local last_fixed_t, frame, accumulator = 0, 0, 0

	runservice.PreAnimation:Connect(function()
		schedules_mod.pre_animation_schedule:run(app.world)
	end)
	runservice.PreSimulation:Connect(function()
		schedules_mod.pre_simulation_schedule:run(app.world)
	end)
	runservice.PostSimulation:Connect(function()
		schedules_mod.post_simulation_schedule:run(app.world)
	end)
	if runservice:IsClient() then
		runservice.PreRender:Connect(function()
			schedules_mod.pre_render_schedule:run(app.world)
		end)
	end

	runservice.Heartbeat:Connect(function()
		local cur_t = os.clock()
		local dt = cur_t - last_fixed_t
		last_fixed_t = cur_t

		schedules_mod.update_pipeline[2]:run(app.world)
		schedules_mod.update_pipeline[2]:run(app.world)

		local steps: number
		steps, frame, accumulator = fixedstep_mod.fixed_timestep(dt, frame, accumulator)
		for _ = 1, steps do
			schedules_mod.fixed_pipeline[1]:run(app.world)
			schedules_mod.fixed_pipeline[2]:run(app.world)
			schedules_mod.fixed_pipeline[3]:run(app.world)
			schedules_mod.fixed_pipeline[4]:run(app.world)
			schedules_mod.fixed_pipeline[5]:run(app.world)
		end

		schedules_mod.update_pipeline[3]:run(app.world)
		schedules_mod.update_pipeline[4]:run(app.world)
		schedules_mod.update_pipeline[5]:run(app.world)
	end)

	coroutine.yield()
	return false, "App unexpectedly stopped execution."
end

mod.runner = default_app_runner
mod.DefaultPlugins = default_plugins_mod.default_plugins
mod.plugins = {}
mod.plugins.SchedulesPlugin = schedules_plugin_mod.schedules_plugin
mod.schedules = schedules_mod.schedule_map
mod.fixedstep = fixedstep_mod

return mod
