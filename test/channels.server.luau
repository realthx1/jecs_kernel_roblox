--[[
    Jecs_kernel_roblox adds systems to update Channels from `realthx1/channels`.
    Channels are updated every frame on the First schedule.
    Technically, messages are retained in registered channels for 2 frames.
    This example showcases how to register channels for updates.
]]

local krnl = require("../roblox_packages/jecs_kernel")
local jecs = require("../roblox_packages/jecs")
local krnl_roblox = require("../jecs_kernel_roblox")
local luau_channel = require("../roblox_packages/channels")

local schedules = krnl_roblox.schedules

local channel = luau_channel.new<<number>>()

-- Channels need to be registered by creating an entity with the Channel component containing it.
local register_channel_sys = krnl.sys("create_channel_sys", krnl.std_params.World)(function(world: jecs.World)
	local ent = world:entity()
	world:set(ent, krnl_roblox.channel.Channel, channel)
end)

local write_messages = krnl.sys("write_messages_sys", krnl.std_params.World)(function(world: jecs.World)
	luau_channel.write(channel, 10)
end)

local count_messages = krnl.sys("count_messages_sys", krnl.std_params.World)(function(world: jecs.World)
	local len = luau_channel.len(channel)
	-- will print every second
	if len > 0 then print("number of messages", len) end
end)

krnl
	.new_app()
	:add_plugin_group(krnl_roblox.DefaultPlugins) -- DefaultPlugins contains essential plugins for Roblox and the package itself
	:add_system(schedules.Startup.Startup, register_channel_sys)
	:add_systems(schedules.Main.Update, {
		write_messages:run_if({ krnl.std_conditions.interval(1) }),
		count_messages,
	})
	:run(krnl_roblox.app_runner) -- the default runner runs all default schedules
