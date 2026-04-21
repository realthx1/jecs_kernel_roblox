local krnl = require("../roblox_packages/jecs_kernel")
local jecs = require("../roblox_packages/jecs")
local luau_channel = require("../roblox_packages/channels")

local schedules = require("./schedules/schedules").schedule_map

--[=[
    A collection of systems for updating channels from `realthx1/channels`.

    Refer to [/examples/time.luau](./time/quickstart.luau) for a practical example.
]=]
local prelude = {}

--- Jecs component which contains a Channel registered for automatic updates.
local Channel = jecs.component<<luau_channel.Channel<any>>>()
jecs.meta(Channel, jecs.Name, "Channel")

local update_channels_sys = krnl.sys("advance_time_sys", krnl.std_params.World)(function(world: jecs.World)
	for ent, channel in world:query(Channel) do
		luau_channel.update(channel)
	end
end)

--[=[
    A plugin which sets up systems for updating Channels.
    It should be added before all other plugins and systems!

    Refer to [/examples/channels.luau](./examples/channels.luau) for a practical example.
]=]
local channel_plugin = krnl.new_plugin("ChannelPlugin", function(_, app: krnl.App)
	app:add_system(schedules.Main.First, update_channels_sys)
end, nil)

prelude.ChannelPlugin = channel_plugin
prelude.Channel = Channel

return prelude
