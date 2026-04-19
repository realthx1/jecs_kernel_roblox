local krnl = require("../roblox_packages/jecs_kernel")

local schedules_plugin_mod = require("./schedules/plugin")
local time_plugin_mod = require("./time/plugin")

local mod = {}

--[=[
    A plugin group which contains all default plugins for Roblox.

    Ordered list of plugins:
    1. SchedulesPlugin
    2. TimePlugin

    Refer to [/examples/quickstart.luau](./examples/quickstart.luau) for a practical example.
]=]
local default_plugins =
	krnl.new_plugin_group("DefaultPlugins"):add(schedules_plugin_mod.SchedulesPlugin):add(time_plugin_mod.TimePlugin)

mod.default_plugins = default_plugins

return mod
