local krnl = require("../roblox_packages/jecs_kernel")

local schedules_mod = require("./schedules")

local mod = {}

--- A plugin which registers all default schedules. Should be added before all other plugins!
local schedules_plugin = krnl.new_plugin("SchedulesPlugin", function(_, app: krnl.App)
	for _, schedule in schedules_mod.startup_pipeline do
		app:add_schedule(schedule)
	end
	for _, schedule in schedules_mod.update_pipeline do
		app:add_schedule(schedule)
	end
	for _, schedule in schedules_mod.fixed_pipeline do
		app:add_schedule(schedule)
	end
	app:add_schedule(schedules_mod.post_simulation_schedule)
	app:add_schedule(schedules_mod.pre_render_schedule)
	app:add_schedule(schedules_mod.pre_animation_schedule)
	app:add_schedule(schedules_mod.pre_simulation_schedule)
end, nil)

mod.schedules_plugin = schedules_plugin

return mod
