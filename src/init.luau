--!optimize 2
--!native

local default_plugins_mod = require("@self/default_plugins")
local schedules_mod = require("@self/schedules/schedules")
local time_prelude = require("@self/time/prelude")
local default_app_runner = require("@self/runner")

--[=[
    Collection of utilities for the jecs_kernel framework and Roblox.

    Contains:
    - Default schedules and SchedulesPlugin for their setup.
    - Default app runner for the schedules.
    - SyncTime, RealTime and FixedTime resources and TimePlugin for advancing them.

    Refer to [/examples/quickstart.luau](./examples/quickstart.luau) for a practical example.
]=]
local prelude = {}

prelude.app_runner = default_app_runner
prelude.DefaultPlugins = default_plugins_mod.default_plugins
prelude.schedules = schedules_mod.schedule_map
prelude.time = time_prelude

return prelude
