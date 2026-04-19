local krnl = require("../../roblox_packages/jecs_kernel")

local schedules = require("../schedules/schedules").schedule_map

local advance = require("./advance")

local mod = {}

--[=[
    A plugin which sets up time resources and advances them.
    It should be added before all other plugins and systems!

    Refer to [/examples/quickstart.luau](./examples/time_plugin.luau) for a practical example.
]=]
local time_plugin = krnl.new_plugin("TimePlugin", function(_, app: krnl.App)
	app:add_system(schedules.Main.First, advance.advance_real_time_sys)
end, nil)

mod.TimePlugin = time_plugin

return mod
