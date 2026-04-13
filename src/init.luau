--!optimize 2
--!native

local runservice = game:GetService("RunService")

local krnl = require("./roblox_packages/jecs_kernel")

local default_plugins_mod = require("@self/default_plugins")
local schedules_mod = require("@self/schedules")
local fixedstep_mod = require("@self/fixedstep")
local schedules_plugin_mod = require("@self/schedules_plugin")

local schedule_run_cached = krnl.schedule._scope.run
local krnl_flags = krnl.flags

--[=[
    Collection of schedules and plugins for the jecs_kernel package and Roblox.
]=]
local mod = {}

local function run_schedule(app: krnl.App, schedule: krnl.Schedule, name: string)
	local debug_info = krnl_flags.debug_info
	local unsafe_execution = not krnl_flags.error_boundaries

	if debug_info then debug.profilebegin("Schedule(" .. name .. ")") end
	if unsafe_execution then
		schedule_run_cached(schedule, app.world)
	else
		xpcall(schedule_run_cached, function(err: string?)
			warn(
				"jecs_kernel_roblox: An error was caught while running schedule '"
					.. name
					.. "'\n"
					.. debug.traceback(err)
			)
		end, schedule, app.world)
	end
	if debug_info then debug.profileend() end
end

local function default_app_runner(app: krnl.App): (boolean, string)
	run_schedule(app, schedules_mod.startup_pipeline[1], "PreStartup")
	run_schedule(app, schedules_mod.startup_pipeline[2], "Startup")
	run_schedule(app, schedules_mod.startup_pipeline[3], "PostStartup")

	local last_fixed_t, frame, accumulator = 0, 0, 0

	runservice.PreAnimation:Connect(function()
		run_schedule(app, schedules_mod.pre_animation_schedule, "PreAnimation")
	end)
	runservice.PreSimulation:Connect(function()
		run_schedule(app, schedules_mod.pre_simulation_schedule, "PreSimulation")
	end)
	runservice.PostSimulation:Connect(function()
		run_schedule(app, schedules_mod.post_simulation_schedule, "PostSimulation")
	end)
	if runservice:IsClient() then
		runservice.PreRender:Connect(function()
			run_schedule(app, schedules_mod.pre_render_schedule, "PreRender")
		end)
	end

	runservice.Heartbeat:Connect(function()
		local cur_t = os.clock()
		local dt = cur_t - last_fixed_t
		last_fixed_t = cur_t

		run_schedule(app, schedules_mod.update_pipeline[2], "First")
		run_schedule(app, schedules_mod.update_pipeline[2], "PreUpdate")

		local steps: number
		steps, frame, accumulator = fixedstep_mod.fixed_timestep(dt, frame, accumulator)
		for _ = 1, steps do
			run_schedule(app, schedules_mod.fixed_pipeline[1], "FixedFirst")
			run_schedule(app, schedules_mod.fixed_pipeline[2], "FixedPreUpdate")
			run_schedule(app, schedules_mod.fixed_pipeline[3], "FixedUpdate")
			run_schedule(app, schedules_mod.fixed_pipeline[4], "FixedPostUpdate")
			run_schedule(app, schedules_mod.fixed_pipeline[5], "FixedLast")
		end

		run_schedule(app, schedules_mod.update_pipeline[3], "Update")
		run_schedule(app, schedules_mod.update_pipeline[4], "PostUpdate")
		run_schedule(app, schedules_mod.update_pipeline[5], "Last")
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
