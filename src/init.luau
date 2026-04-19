--!optimize 2
--!native

local default_plugins_mod = require("@self/default_plugins")
local schedules_mod = require("@self/schedules/schedules")
local schedules_plugin_mod = require("@self/schedules/plugin")
local time_plugin_mod = require("@self/time/plugin")
local time_params_mod = require("@self/time/params")
local time_resources_mod = require("@self/time/resources")
local default_app_runner = require("@self/runner")

--[=[
    Collection of utilities for the jecs_kernel framework and Roblox.

    Contains:
    - Default schedules and SchedulesPlugin for their setup.
    - Default app runner for the schedules.
    - Default time resources for tracking elapsed time.
    - TimePlugin for advancing default time resources.

    Refer to [/examples/quickstart.luau](./examples/quickstart.luau) for a practical example.
]=]
local mod = {}

mod.runner = default_app_runner
mod.DefaultPlugins = default_plugins_mod.default_plugins
mod.schedules = schedules_mod.schedule_map

mod.params = {}
mod.params.time = time_params_mod

mod.resources = {}
mod.resources.time = time_resources_mod

mod.plugins = {}
mod.plugins.SchedulesPlugin = schedules_plugin_mod.SchedulesPlugin
mod.plugins.TimePlugin = time_plugin_mod.TimePlugin

return mod
