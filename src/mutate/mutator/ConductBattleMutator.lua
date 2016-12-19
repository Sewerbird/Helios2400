--ConductBattleMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local DamageArmyMutator = require 'src/mutate/mutator/DamageArmyMutator'
--local MoveArmyMutator = require 'src/mutate/mutator/MoveArmyMutator'
local ConductBattleMutator = Mutator:extend('ConductBattleMutator', {
	target_city = nil,
	new_player_owner = nil,
	old_player_owner = nil
})

function ConductBattleMutator:init ( attacker, defender )
	ConductBattleMutator.super:init()
	self.attacker = attacker
	self.defender = defender
end

function ConductBattleMutator:apply ( registry )
	local attacker = registry:getComponent(self.attacker, "GameInfo")
	local defender = registry:getComponent(self.defender, "GameInfo")

	local phase_order = {'ewar','indirect','direct','close'}
	local combat_finished = false
	for i, phase in ipairs(phase_order) do
		if not combat_finished then
			local attacker_casualties = math.max((defender.assault_rating[phase] or 0) - (attacker.defense_rating[phase] or 0),0)
			local defender_casualties = math.max((attacker.assault_rating[phase] or 0) - (defender.defense_rating[phase] or 0),0)

			DamageArmyMutator:new(self.attacker, attacker_casualties):apply(registry)
			DamageArmyMutator:new(self.defender, defender_casualties):apply(registry)

			attacker = registry:getComponent(self.attacker, "GameInfo")
			defender = registry:getComponent(self.defender, "GameInfo")

			if attacker.is_destroyed or defender.is_destroyed then
				combat_finished = true
			end
		end
	end

	if defender.is_destroyed and not attacker.is_destroyed then
		--Attacker victorious!
	elseif attacker.is_destroyed and not defender.is_destroyed then
		--Disastrous assault!
	elseif attacker.is_destroyed and defender.is_destroyed then
		--Mutual destruction
	else
		--Draw
	end

end

function ConductBattleMutator:rollback ( registry )
	error("Make battles rollbackable")
end

return ConductBattleMutator