local krnl = require("../roblox_packages/jecs_kernel")

local schedules_plugin_mod = require("./schedules_plugin")

local mod = {}

--[=[
    A plugin group which contains all default plugins for Roblox.

    Ordered list of added plugins:
    * SchedulesPlugin
]=]
local default_plugins = krnl.new_plugin_group("DefaultPlugins"):add(schedules_plugin_mod.schedules_plugin)

mod.default_plugins = default_plugins

return mod
