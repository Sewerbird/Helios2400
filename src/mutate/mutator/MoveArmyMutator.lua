--MoveArmyMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local CaptureCityMutator = require 'src/mutate/mutator/CaptureCityMutator'
local ConductBattleMutator = require 'src/mutate/mutator/ConductBattleMutator'
local MoveArmyMutator = Mutator:extend('MoveArmyMutator', {
	origin_address = nil,
	destination_address = nil,
	move_cost = nil
})

function MoveArmyMutator:init ( target, origin_address, destination_address, move_cost)
	MoveArmyMutator.super:init()
	self.target = target
	self.origin_address = origin_address
	self.destination_address = destination_address
	self.move_cost = move_cost
end

function MoveArmyMutator:isValid ( registry )
	local info = registry:get(self.target, "GameInfo")

	return info.curr_move >= self.move_cost and info.address == self.origin_address
end

function MoveArmyMutator:apply ( registry )
	local info = registry:get(self.target, "GameInfo")
	local new_coord = registry:find("GameInfo", {gs_type = "tile", address = self.destination_address})

	--Check if hex already occupied
	local units_at_location = registry:findAll("GameInfo",{address = self.destination_address, gs_type = "army"})
	local is_foreign_occupied = false
	local attack_target = nil
	if #units_at_location > 0 then
		for i, unit in ipairs(units_at_location) do
			if unit.owner ~= info.owner then
				is_foreign_occupied = true
				attack_target = unit.gid
			end
		end
	end

	if not is_foreign_occupied then
		print('is not foreign occupied')
		info.worldspace_coord = { new_coord.worldspace_coord[1], new_coord.worldspace_coord[2]}
		info.address = self.destination_address
		info.curr_move = info.curr_move - self.move_cost
		registry:publish(self.target .. '_GameInfo',info)

		local city_at_location = registry:find("GameInfo",{address = self.destination_address, gs_type = "city"})
		local mutCapture = nil
		if city_at_location then
			local newOwner = info.owner
			local oldOwner = city_at_location.owner
			print('City at location is : ' .. inspect(city_at_location))
			print('Capturing city ' .. city_at_location.gid .. ' with ' .. newOwner .. ' from ' .. oldOwner)
			CaptureCityMutator:new(city_at_location.gid, newOwner, oldOwner):apply(registry)
		end
	elseif attack_target then
		print('there is an attack target')
		info.curr_move = info.curr_move - self.move_cost
		ConductBattleMutator:new(self.target, attack_target):apply(registry)
	else
		print('is a friendly destination')
		--friendly space
	end

end

function MoveArmyMutator:rollback ( registry )
	local info = registry:get(self.target, "GameInfo")
	info.address = self.origin_address
	info.curr_move = info.curr_move + self.move_cost
	registry:publish(self.target .. '_GameInfo',info)
end

return MoveArmyMutator