--ProduceArmyMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local GameObject = require 'src/GameObject'
local GameInfo = require 'src/component/GameInfo'
local ProduceArmyMutator = Mutator:extend('ProduceArmyMutator', {
	target_address = nil,
	unit_spec = nil
})

function ProduceArmyMutator:init ( unit_spec, target_address )
	ProduceArmyMutator.super:init()
	self.target_address = target_address
	self.unit_spec = unit_spec
end

function ProduceArmyMutator:apply ( registry )
	local producing_city = registry:find("GameInfo", {address = self.target_address, gs_type = "city"})
	print("Placing unit at world coords " .. inspect(producing_city.worldspace_coord) .. " at city named " .. producing_city.city_name)
	local army_info = self.unit_spec
    army_info.gs_type = "army"
    army_info.map = 'Earth'
    army_info.army_name = producing_city.owner
    army_info.address = producing_city.address
    army_info.worldspace_coord = producing_city.worldspace_coord
    army_info.owner = producing_city.owner
    army_info.turns_owned = {[producing_city.owner] = 1}
    army_info.curr_hp = army_info.max_hp
    army_info.curr_move = army_info.max_move

    self.produced_unit = registry:make('gsArmy',{GameInfo:new(army_info)}) or nil

    registry:publish("placeArmy", {map = army_info.map, unit = self.produced_unit})
	registry:publish(producing_city.gid .. '_GameInfo', producing_city)
end

function ProduceArmyMutator:rollback ( registry )
	error("TODO: make rollback function for ProduceArmyMutator")
end

return ProduceArmyMutator