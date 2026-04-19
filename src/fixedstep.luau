--!optimize 2
--!native

-- kindly "borrowed" from lockstep

local FIXED_DELTA = 1 / 64
local MAX_DELTA = 1 / 4

local mod = {}

local function fixed_timestep(dt: number, frame: number, accumulator: number): (number, number, number)
	accumulator += math.min(dt, MAX_DELTA)

	local steps = 0

	if accumulator > 0 then
		steps = accumulator // FIXED_DELTA
		frame += steps
		accumulator -= steps * FIXED_DELTA
	end

	return steps, frame, accumulator
end

mod.fixed_timestep = fixed_timestep
mod.FIXED_DELTA = FIXED_DELTA
mod.MAX_DELTA = MAX_DELTA

return mod
