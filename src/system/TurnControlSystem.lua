--TurnControlSystem.lua

--[[
	The TurnControlSystem maintains references to player objects, and is responsible for switching the current player.
	The targetCollection of the TCS is a Ring of player GameInfo ids.
]]--

local System = require 'src/System'
local Ring = require 'src/structure/Ring'
local EndTurnMutator = require 'src/mutate/mutator/EndTurnMutator'
local StartTurnMutator = require 'src/mutate/mutator/StartTurnMutator'

local TurnControlSystem = System:extend("TurnControlSystem",{
})

function TurnControlSystem:init( registry, targetCollection )
	TurnControlSystem.super.init(self, registry, targetCollection)

	if not targetCollection then
		local players = registry:findComponents("GameInfo", {gs_type="player"})
		self.targetCollection = Ring:new()
		for i, player in ipairs(players) do
			self.targetCollection:add(player.player_name)
		end
	end

	local unsubEndturn= self.registry:subscribe("triggerEndTurn", function (this, msg)
		self:endTurn()
	end)
end

function TurnControlSystem:begin()
	local new_player = self.registry:findComponent("GameInfo",{gs_type="player", player_name=self.targetCollection:current()})
	self.registry:publish("beginTurn",new_player)
end

function TurnControlSystem:endTurn ()

	local oldPlayer = self.targetCollection:current()
	self.targetCollection:next()
	local newPlayer = self.targetCollection:current()
	local mutEndTurn = EndTurnMutator:new(oldPlayer,newPlayer)
	local mutNewTurn = StartTurnMutator:new(newPlayer)
	print("Changed player to " .. self.targetCollection:current())

	self.registry:publish("IMMEDIATE_MUTATE", mutEndTurn)
	self.registry:publish("IMMEDIATE_MUTATE", mutNewTurn)
end

return TurnControlSystem