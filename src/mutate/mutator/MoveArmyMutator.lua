--MoveArmyMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local CaptureCityMutator = require 'src/mutate/mutator/CaptureCityMutator'
local MoveArmyMutator = Mutator:extend('MoveArmyMutator', {
	origin_address = nil,
	destination_address = nil,
	move_cost = nil
})

function MoveArmyMutator:init ( target, origin_address, destination_address, move_cost )
	MoveArmyMutator.super:init()
	self.target = target
	self.origin_address = origin_address
	self.destination_address = destination_address
	self.move_cost = move_cost
end

function MoveArmyMutator:isValid ( registry )
	local info = registry:get(self.target):getComponent("GameInfo")
	return info.curr_move >= self.move_cost
end

function MoveArmyMutator:apply ( registry )
	local being_moved = registry:get(self.target)
	local info = being_moved:getComponent("GameInfo")
	registry:summarize()
	print('moving army ' .. self.target .. ' from ' .. self.origin_address .. ' to ' .. self.destination_address .. ' costing ' .. self.move_cost)
	print('looking for address ' .. self.destination_address)
	local new_coord = registry:findComponent("GameInfo", {gs_type = "tile", address = self.destination_address})
	print("New_coord : " .. inspect(new_coord.worldspace_coord))
	info.address = self.destination_address
	info.curr_move = info.curr_move - self.move_cost
	info.worldspace_coord = { new_coord.worldspace_coord[1], new_coord.worldspace_coord[2]}
	registry:publish(self.target .. '_GameInfo',info)
	registry:publish(self.target .. ':moved', {
		subject = "moved", 
		origin_address = self.origin_address, 
		destination_address = self.destination_address,
		move_cost = self.move_cost
	})

	local city_at_location = registry:findComponent("GameInfo",{address = self.destination_address, gs_type = "city"})
	local mutCapture = nil
	if city_at_location then
		local newOwner = info.owner
		local oldOwner = city_at_location.owner
		print('Capturing city ' .. city_at_location.gid .. ' with ' .. newOwner .. ' from ' .. oldOwner)
		mutCapture = CaptureCityMutator:new(city_at_location.gid, newOwner, oldOwner)
	end
		
	if mutCapture then 
		registry:publish("IMMEDIATE_MUTATE",mutCapture) 
	end
end

function MoveArmyMutator:rollback ( registry )
	local being_unmoved = registry:get(self.target)
	local info = being_unmoved:getComponent("GameInfo")
	info.address = self.origin_address
	info.curr_move = info.curr_move + self.move_cost
	registry:publish(self.target .. '_GameInfo',info)
	registry:publish(self.target .. ':moved', { 
		subject = "moved", 
		origin_address = self.destination_address, 
		destination_address = self.origin_address,
		move_cost = self.move_cost 
	})
end

return MoveArmyMutator