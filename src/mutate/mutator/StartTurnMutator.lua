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

	local new_player = registry:findComponent("GameInfo",{gs_type="player", player_name=self.new_player})
	print('BEGINNING TURN WITH ' .. self.new_player)
	registry:publish("beginTurn",new_player)

end

function StartTurnMutator:rollback ( registry )
	error('TODO: Make Start Turn Mutator Rollbackable')
end

return StartTurnMutator