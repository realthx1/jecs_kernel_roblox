local krnl = require("../roblox_packages/jecs_kernel")

local mod = {}

local pre_animation_schedule = krnl.schedule.new()
local pre_simulation_schedule = krnl.schedule.new()
local post_simulation_schedule = krnl.schedule.new()
local pre_render_schedule = krnl.schedule.new()

local update_pipeline: { krnl.Schedule } = {
	krnl.schedule.new(),
	krnl.schedule.new(),
	krnl.schedule.new(),
	krnl.schedule.new(),
	krnl.schedule.new(),
}

local startup_pipeline: { krnl.Schedule } = {
	krnl.schedule.new(),
	krnl.schedule.new(),
	krnl.schedule.new(),
}

local fixed_pipeline: { krnl.Schedule } = {
	krnl.schedule.new(),
	krnl.schedule.new(),
	krnl.schedule.new(),
	krnl.schedule.new(),
	krnl.schedule.new(),
}

--- Contains all schedules which are ran by the runner.
local schedule_map = table.freeze({
	--- Contains all schedules which are sequentially ran on HeartBeat.
	Main = table.freeze({
		--- Runs before all Main schedules.
		First = update_pipeline[1],
		--- Runs after First and before PreUpdate.
		PreUpdate = update_pipeline[2],
		--- Primary schedule that runs after PreUpdate and before PostUpdate.
		Update = update_pipeline[3],
		--- Runs after Update and before Last.
		PostUpdate = update_pipeline[4],
		--- Runs after all Main schedules.
		Last = update_pipeline[5],
	}),
	--- Contains all schedules which are ran sequentially after Main's PreUpdate. They use a fixed timestep and can be ran multiple times.
	FixedMain = table.freeze({
		FixedFirst = fixed_pipeline[1],
		FixedPreUpdate = fixed_pipeline[2],
		FixedUpdate = fixed_pipeline[3],
		FixedPostUpdate = fixed_pipeline[4],
		FixedLast = fixed_pipeline[5],
	}),
	--- Contains all schedules which are ran on respective RunService events.
	RunService = table.freeze({
		--- Runs on PreAnimation event.
		PreAnimation = pre_animation_schedule,
		--- Runs on PreSimulation event.
		PreSimulation = pre_simulation_schedule,
		--- Runs on PostSimulation event.
		PostSimulation = post_simulation_schedule,
		--- Alias for Main's Update schedule.
		HeartBeat = update_pipeline[3],
		--- Runs on PreRender. This schedule won't run on server!
		PreRender = pre_render_schedule,
	}),
	--- Contains all schedules which are ran once before other schedules.
	Startup = table.freeze({
		--- Runs before Startup.
		PreStartup = startup_pipeline[1],
		--- Primary Startup schedule which runs after PreStartup and before PostStartup.
		Startup = startup_pipeline[2],
		--- Runs after Startup.
		PostStartup = startup_pipeline[3],
	}),
})

mod.schedule_map = schedule_map
mod.pre_animation_schedule = pre_animation_schedule
mod.pre_simulation_schedule = pre_simulation_schedule
mod.post_simulation_schedule = post_simulation_schedule
mod.pre_render_schedule = pre_render_schedule
mod.update_pipeline = update_pipeline
mod.startup_pipeline = startup_pipeline
mod.fixed_pipeline = fixed_pipeline

return mod
