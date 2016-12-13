--StartTurnMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
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

	--Check the Win Condition
	local new_player = registry:findComponent("GameInfo",{gs_type="player", player_name=self.new_player})
	registry:publish("beginTurn",new_player)
	local playerControlsByzantium = false
	local playerHasWonTheGame = false
	local byzantium = nil
	for i, city in ipairs(registry:findComponents("GameInfo", {gs_type="city", owner=self.new_player})) do
		city.turns_owned[self.new_player] = city.turns_owned[self.new_player] and city.turns_owned[self.new_player] + 1 or 1
		if city.is_planetary_capitol and city.turns_owned[self.new_player] == 5 then
			--Win Game
			playerHasWonTheGame = true
			byzantium = city
		elseif city.is_planetary_capitol then
			playerControlsByzantium = true
			byzantium = city
		end
	end

	--Refresh all Players' units' movement budgets
	for i, army in ipairs(registry:findComponents("GameInfo", {gs_type="army", owner=self.new_player})) do
		army.curr_move = army.max_move
		registry:publish(army.gid .. "_GameInfo", army)
	end

	--Publish events
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