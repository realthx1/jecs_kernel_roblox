local jecs = require("../../roblox_packages/jecs")
local luau_time = require("../../roblox_packages/luau_time")

local mod = {}

--- A clock responsible for tracking time for systems in fixed schedules.
--- This clock is useless for systems that run in other systems.
local FixedTime = jecs.component<<luau_time.Time>>()
jecs.meta(FixedTime, FixedTime, luau_time.time.new())

--- A clock responsible for tracking real time using `os.clock()`.
local RealTime = jecs.component<<luau_time.Time>>()
jecs.meta(RealTime, RealTime, luau_time.time.from_seconds(os.clock()))

mod.FixedTime = FixedTime
mod.RealTime = RealTime

return mod
