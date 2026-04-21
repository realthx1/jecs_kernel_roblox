local jecs = require("../../roblox_packages/jecs")
local luau_time = require("../../roblox_packages/luau_time")

local mod = {}

--- A clock responsible for tracking time for systems in fixed schedules.
--- This clock is useless for systems that run in other systems.
local FixedTime = jecs.component<<luau_time.Time>>()
jecs.meta(FixedTime, FixedTime, luau_time.time.new())
jecs.meta(FixedTime, jecs.Name, "FixedTime")

--- A clock responsible for tracking real time using `os.clock()`.
local RealTime = jecs.component<<luau_time.Time>>()
jecs.meta(RealTime, RealTime, luau_time.time.from_seconds(os.clock()))
jecs.meta(RealTime, jecs.Name, "RealTime")

--- A clock responsible for tracking time synced between the server and clients using `workspace:GetServerTimeNow()`.
local SyncTime = jecs.component<<luau_time.Time>>()
jecs.meta(SyncTime, SyncTime, luau_time.time.from_seconds(workspace:GetServerTimeNow()))
jecs.meta(SyncTime, jecs.Name, "SyncTime")

mod.FixedTime = FixedTime
mod.RealTime = RealTime
mod.SyncTime = SyncTime

return mod
