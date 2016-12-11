--EndTurnMutator.lua
local class = require 'lib/30log'
local Mutator = require 'src/mutate/Mutator'
local EndTurnMutator = Mutator:extend('EndTurnMutator', {
	target_city = nil,
	new_player_owner = nil,
	old_player_owner = nil
})

function EndTurnMutator:init ( old_player, new_player)
	EndTurnMutator.super:init()
	self.new_player = new_player
	self.old_player = old_player
end

function EndTurnMutator:apply ( registry )

	local old_player = registry:findComponent("GameInfo",{gs_type="player", player_name=self.old_player})
	for i, player in ipairs(registry:findComponents("GameInfo", {gs_type="player"})) do
		player.is_current = false
	end
	local new_player = registry:findComponent("GameInfo",{gs_type="player", player_name=self.new_player})
	new_player.is_current = true

	registry:publish("endTurn",old_player)

end

function EndTurnMutator:rollback ( registry )
	error('TODO: Make End Turn Mutator Rollbackable')
end

return EndTurnMutator