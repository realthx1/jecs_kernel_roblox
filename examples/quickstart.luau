local krnl = require("@pkg/jecs_kernel")
local jecs = require("@pkg/jecs")
local krnl_roblox = require("@krnl_roblox")

local schedules = krnl_roblox.schedules

local human_tag = jecs.tag()
local health_component = jecs.component<<number>>()

local human_add_sys = krnl.sys("Human Add", krnl.std.system_params.World)(function(world: jecs.World)
	for i = 1, 10 do
		local human_ent = world:entity()
		world:add(human_ent, human_tag)
		world:set(human_ent, health_component, math.random(10, 100))
	end
end)

local human_damage_sys = krnl.sys("Human Damage", krnl.std.system_params.World)(function(world: jecs.World)
	for human_ent, health in world:query(health_component):with(human_tag) do
		world:set(human_ent, health_component, math.max(0, health - 2))
	end
end)

local human_death_sys = krnl.sys("Human Death", krnl.std.system_params.World)(function(world: jecs.World)
	for human_ent, health in world:query(health_component):with(human_tag) do
		if health == 0 then
			print("Human", human_ent, "died!")
			world:delete(human_ent)
		end
	end
end)

krnl
	.new_app()
	:add_plugin_group(krnl_roblox.DefaultPlugins) -- DefaultPlugins contains essential plugins for Roblox and the package itself
	:add_systems(schedules.Startup.Startup, { human_add_sys })
	:add_systems(schedules.FixedMain.FixedUpdate, { human_damage_sys })
	:add_systems(schedules.Main.PostUpdate, { human_death_sys })
	:run(krnl_roblox.runner) -- the default runner runs all default schedules
