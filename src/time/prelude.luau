local plugin = require("./plugin")
local resources = require("./resources")

--[=[
    A collection of utilities for working with time and jecs_kernel.

    Refer to [/examples/time.luau](./time/quickstart.luau) for a practical example.
]=]
local prelude = {}

prelude.SyncTime = resources.SyncTime
prelude.FixedTime = resources.FixedTime
prelude.RealTime = resources.RealTime

prelude.TimePlugin = plugin.TimePlugin

return prelude
