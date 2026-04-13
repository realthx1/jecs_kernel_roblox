--!optimize 2
--!native

local runservice = game:GetService("RunService")

local krnl = require("./roblox_packages/jecs_kernel")

local default_plugins_mod = require("@self/default_plugins")
local schedules_mod = require("@self/schedules")
local fixedstep_mod = require("@self/fixedstep")
local schedules_plugin_mod = require("@self/schedules_plugin")

--[=[
    Collection of schedules and plugins for the jecs_kernel package and Roblox.
]=]
local mod = {}

local function run_schedule(app: krnl.App, schedule: krnl.Schedule, name: string)
	local debug_info = krnl.flags.debug_info
	local unsafe_execution = krnl.flags.error_boundaries
	if debug_info then debug.profilebegin(name) end
	if unsafe_execution then
		schedule:run(app.world)
	else
		pcall(schedule.run, schedule, app.world)
	end
	if debug_info then debug.profileend() end
end

local function default_app_runner(app: krnl.App): (boolean, string)
	run_schedule(app, schedules_mod.startup_pipeline[1], "schedule PreStartup")
	run_schedule(app, schedules_mod.startup_pipeline[2], "schedule Startup")
	run_schedule(app, schedules_mod.startup_pipeline[3], "schedule PostStartup")

	local last_fixed_t, frame, accumulator = 0, 0, 0

	runservice.PreAnimation:Connect(function()
		run_schedule(app, schedules_mod.pre_animation_schedule, "schedule PreAnimation")
	end)
	runservice.PreSimulation:Connect(function()
		run_schedule(app, schedules_mod.pre_simulation_schedule, "schedule PreSimulation")
	end)
	runservice.PostSimulation:Connect(function()
		run_schedule(app, schedules_mod.post_simulation_schedule, "schedule PostSimulation")
	end)
	if runservice:IsClient() then
		runservice.PreRender:Connect(function()
			run_schedule(app, schedules_mod.pre_render_schedule, "schedule PreRender")
		end)
	end

	runservice.Heartbeat:Connect(function()
		local cur_t = os.clock()
		local dt = cur_t - last_fixed_t
		last_fixed_t = cur_t

		run_schedule(app, schedules_mod.update_pipeline[2], "schedule First")
		run_schedule(app, schedules_mod.update_pipeline[2], "schedule PreUpdate")

		local steps: number
		steps, frame, accumulator = fixedstep_mod.fixed_timestep(dt, frame, accumulator)
		for _ = 1, steps do
			run_schedule(app, schedules_mod.fixed_pipeline[1], "schedule FixedFirst")
			run_schedule(app, schedules_mod.fixed_pipeline[2], "schedule FixedPreUpdate")
			run_schedule(app, schedules_mod.fixed_pipeline[3], "schedule FixedUpdate")
			run_schedule(app, schedules_mod.fixed_pipeline[4], "schedule FixedPostUpdate")
			run_schedule(app, schedules_mod.fixed_pipeline[5], "schedule FixedLast")
		end

		run_schedule(app, schedules_mod.update_pipeline[3], "schedule Update")
		run_schedule(app, schedules_mod.update_pipeline[4], "schedule PostUpdate")
		run_schedule(app, schedules_mod.update_pipeline[5], "schedule Last")
	end)

	coroutine.yield()
	return false, "App unexpectedly stopped execution."
end

mod.runner = default_app_runner
mod.DefaultPlugins = default_plugins_mod.default_plugins
mod.plugins = {}
mod.plugins.SchedulesPlugin = schedules_plugin_mod.schedules_plugin
mod.schedules = schedules_mod.schedule_map

return mod
