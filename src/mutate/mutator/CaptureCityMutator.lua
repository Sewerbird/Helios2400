--CaptureCityMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local CaptureCityMutator = Mutator:extend('CaptureCityMutator', {
	target_city = nil,
	new_player_owner = nil,
	old_player_owner = nil
})

function CaptureCityMutator:init ( target_city, new_player_owner, old_player_owner )
	CaptureCityMutator.super:init()
	self.target_city = target_city
	self.new_player_owner = new_player_owner
	self.old_player_owner = old_player_owner
end

function CaptureCityMutator:apply ( registry )
	local captured_city = registry:get(self.target_city):getComponent("GameInfo")
	captured_city.owner = self.new_player_owner
	registry:publish(self.target_city .. '_GameInfo', captured_city)
end

function CaptureCityMutator:rollback ( registry )
	local captured_city = registry:get(self.target_city):getComponent("GameInfo")
	captured_city.owner = self.old_player_owner
	registry:publish(self.target_city .. '_GameInfo', captured_city)
end

return CaptureCityMutator