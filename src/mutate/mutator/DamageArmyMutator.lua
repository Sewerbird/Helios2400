--DamageArmyMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local DamageArmyMutator = Mutator:extend('DamageArmyMutator', {
	target_city = nil,
	new_player_owner = nil,
	old_player_owner = nil
})

function DamageArmyMutator:init ( damagedArmy, damageInflicted)
	DamageArmyMutator.super:init()
	self.target = damagedArmy
	self.damage = damageInflicted
end

function DamageArmyMutator:apply ( registry )
	local damaged = registry:getComponent(self.target,"GameInfo")
	damaged.curr_hp = damaged.curr_hp - self.damage
	if damaged.curr_hp <= 0 then
		damaged.is_destroyed = true
		damaged.address = nil
	end
	registry:publish(self.target .. '_GameInfo', damaged)
end

function DamageArmyMutator:rollback ( registry )
	local damaged = registry:getComponent(self.target,"GameInfo")
	damaged.curr_hp = damaged.curr_hp + self.damage
	if damaged.curr_hp > 0 then
		damaged.is_destroyed = nil
		damaged.address = nil
	end
	registry:publish(self.target .. '_GameInfo', damaged)
end

return DamageArmyMutator