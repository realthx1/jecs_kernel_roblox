--!optimize 2
--!native

local runservice = game:GetService("RunService")

local krnl = require("../roblox_packages/jecs_kernel")

local advance = require("./time/advance")
local schedules_mod = require("./schedules/schedules")
local fixedstep_mod = require("./fixedstep")

--[=[
    Default app runner.
    This runner runs only the default schedules.

    Refer to [/examples/quickstart.luau](./examples/quickstart.luau) for a practical example.
]=]
local function default_app_runner(app: krnl.App): (boolean, string)
	local world = app.world

	schedules_mod.startup_pipeline[1]:run(world)
	schedules_mod.startup_pipeline[2]:run(world)
	schedules_mod.startup_pipeline[3]:run(world)

	local last_fixed_t, frame, accumulator = 0, 0, 0

	runservice.PreAnimation:Connect(function()
		schedules_mod.pre_animation_schedule:run(world)
	end)
	runservice.PreSimulation:Connect(function()
		schedules_mod.pre_simulation_schedule:run(world)
	end)
	runservice.PostSimulation:Connect(function()
		schedules_mod.post_simulation_schedule:run(world)
	end)
	if runservice:IsClient() then
		runservice.PreRender:Connect(function()
			schedules_mod.pre_render_schedule:run(world)
		end)
	end

	runservice.Heartbeat:Connect(function()
		local cur_t = os.clock()
		local dt = cur_t - last_fixed_t
		last_fixed_t = cur_t

		schedules_mod.update_pipeline[1]:run(world)
		schedules_mod.update_pipeline[2]:run(world)

		local steps: number
		steps, frame, accumulator = fixedstep_mod.fixed_timestep(dt, frame, accumulator)
		for _ = 1, steps do
			advance.advance_fixed_time(world, fixedstep_mod.FIXED_DELTA)

			schedules_mod.fixed_pipeline[1]:run(world)
			schedules_mod.fixed_pipeline[2]:run(world)
			schedules_mod.fixed_pipeline[3]:run(world)
			schedules_mod.fixed_pipeline[4]:run(world)
			schedules_mod.fixed_pipeline[5]:run(world)
		end

		schedules_mod.update_pipeline[3]:run(world)
		schedules_mod.update_pipeline[4]:run(world)
		schedules_mod.update_pipeline[5]:run(world)
	end)

	coroutine.yield()
	return false, "App unexpectedly stopped execution."
end

return default_app_runner
