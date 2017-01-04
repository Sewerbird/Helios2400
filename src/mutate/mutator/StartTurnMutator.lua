--StartTurnMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local CreditPlayerBalanceMutator = require 'src/mutate/mutator/CreditPlayerBalanceMutator'
local ProduceArmyMutator = require 'src/mutate/mutator/ProduceArmyMutator'
local StartTurnMutator = Mutator:extend('StartTurnMutator', {
	target_city = nil,
	new_player_owner = nil,
	old_player_owner = nil
})

function StartTurnMutator:init ( new_player )
	StartTurnMutator.super:init()
	self.new_player = new_player
end

function StartTurnMutator:apply ( registry )

	local new_player = registry:find("GameInfo",{gs_type="player", player_name=self.new_player})
	local turn_income = 0
	local playerControlsByzantium = false
	local playerHasWonTheGame = false
	local byzantium = nil
	for i, city in ipairs(registry:findAll("GameInfo", {gs_type="city", owner=self.new_player})) do

		--Check the Win Condition
		city.turns_owned[self.new_player] = city.turns_owned[self.new_player] and city.turns_owned[self.new_player] + 1 or 1
		if city.is_planetary_capitol and city.turns_owned[self.new_player] == 5 then
			--Win Game
			playerHasWonTheGame = true
			byzantium = city
		elseif city.is_planetary_capitol then
			playerControlsByzantium = true
			byzantium = city
		end

		--Add up income
		turn_income = turn_income + (city.base_income_rate or 0)

		--Update unit build points
		if #city.build_queue > 0 then
			local bp_spent = city.base_build_point_rate
			local overrun = (city.build_queue[1].base_build_point_cost - (city.build_queue[1].build_points_spent + bp_spent))
			local i = 1
			while overrun <= 0 and city.build_queue[1] do
				--Unit produced
				city.build_queue[1].build_points_spent = city.build_queue[1].build_points_spent + bp_spent + overrun
				bp_spent = bp_spent + overrun
				registry:publish("IMMEDIATE_MUTATE", ProduceArmyMutator:new(city.build_queue[1],city.address))
				overrun = (city.build_queue[1].base_build_point_cost - (city.build_queue[1].build_points_spent + bp_spent))
				table.remove(city.build_queue, 1)
				i = i + 1
			end
			if overrun > 0 and #city.build_queue > 0 then
				city.build_queue[1].build_points_spent = city.build_queue[1].build_points_spent + bp_spent
			end
		end
	end

	--Refresh all Players' units' movement budgets
	local turn_upkeep = 0
	for i, army in ipairs(registry:findAll("GameInfo", {gs_type="army", owner=self.new_player})) do
		army.curr_move = army.max_move
		registry:publish(army.gid .. "_GameInfo", army)
		turn_upkeep = turn_upkeep + 1
	end

	--Give player their income
	local mutPayment = CreditPlayerBalanceMutator:new(self.new_player, turn_income - turn_upkeep)
	registry:publish("IMMEDIATE_MUTATE",mutPayment) 

	--Publish events
	print("Beginning turn for " .. inspect(new_player))
	registry:publish("beginTurn",new_player)
	if playerHasWonTheGame then
		registry:publish("gameOverByzantiumWin", {player=new_player,byzantium=byzantium})
	elseif playerControlsByzantium then
		registry:publish("byzantiumOwned", {player=new_player,byzantium=byzantium})
	end

end

function StartTurnMutator:rollback ( registry )
	error('TODO: Make Start Turn Mutator Rollbackable')
end

return StartTurnMutator