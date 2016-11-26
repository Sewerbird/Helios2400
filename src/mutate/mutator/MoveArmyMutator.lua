--MoveArmyMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local MoveArmyMutator = Mutator:extend('MoveArmyMutator', {
	origin_address = nil,
	destination_address = nil,
	move_cost = nil
})

function MoveArmyMutator:init ( target, origin_info, destination_info, origin_address, destination_address, move_cost )
	MoveArmyMutator.super:init()
	self.target = target
	self.origin_info = origin_info
	self.destination_info = destination_info
	self.origin_address = origin_address
	self.destination_address = destination_address
	self.move_cost = move_cost
end

function MoveArmyMutator:apply ( registry )
	local being_moved = registry:get(self.target)
	local info = being_moved:getComponent("GameInfo")
	info.address = self.destination_address
	info.curr_move = info.curr_move - self.move_cost
	registry:publish(self.target, { 
		subject = "moved", 
		origin_info = self.origin_info,
		destination_info = self.destination_info,
		origin_address = self.origin_address, 
		destination_address = self.destination_address,
		move_cost = self.move_cost
	})
end

function MoveArmyMutator:rollback ( registry )
	local being_unmoved = registry:get(self.target)
	local info = being_unmoved:getComponent("GameInfo")
	info.address = self.origin_address
	info.curr_move = info.curr_move + self.move_cost
	registry:publish(self.target, { 
		subject = "moved", 
		destination_info = self.origin_info,
		origin_info = self.destination_info,
		origin_address = self.destination_address, 
		destination_address = self.origin_address,
		move_cost = self.move_cost 
	})
end

return MoveArmyMutator