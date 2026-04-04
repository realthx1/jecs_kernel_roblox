local krnl = require(script.Parent.Parent.roblox_packages.jecs_kernel)
local krnl_roblox = require(script.Parent.Parent.jecs_kernel_roblox)
local jecs = require(script.Parent.Parent.roblox_packages.jecs)

local schedules = krnl_roblox.schedules
local sys = krnl.system.system_new

local world = jecs.world()
local human_tag = world:entity()
local health_component = world:component<<number>>()

local human_add_sys = sys("Human Add")(function()
	for i = 1, 10 do
		local human_ent = world:entity()
		world:add(human_ent, human_tag)
		world:set(human_ent, health_component, math.random(10, 100))
	end
end)

local human_damage_sys = sys("Human Damage")(function()
	for human_ent, health in world:query(health_component):with(human_tag) do
		world:set(human_ent, health_component, math.max(0, health - 2))
	end
end)

local human_death_sys = sys("Human Death")(function()
	for human_ent, health in world:query(health_component):with(human_tag) do
		if health == 0 then
			warn("Human", human_ent, "died!")
			world:delete(human_ent)
		end
	end
end)

krnl.app
	.new_app()
	:add_plugins(krnl_roblox.DefaultPlugins)
	:add_systems(schedules.Startup.Startup, human_add_sys)
	:add_systems(schedules.FixedMain.FixedUpdate, human_damage_sys)
	:add_systems(schedules.Main.PostUpdate, human_death_sys)
	:run(krnl_roblox.runner)
