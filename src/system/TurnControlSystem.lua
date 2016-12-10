--TurnControlSystem.lua

--[[
	The TurnControlSystem maintains references to player objects, and is responsible for switching the current player.
	The targetCollection of the TCS is a Ring of player GameInfo ids.
]]--

local System = require 'src/System'
local Ring = require 'src/structure/Ring'

local TurnControlSystem = System:extend("TurnControlSystem",{
})

function TurnControlSystem:init( registry, targetCollection )
	TurnControlSystem.super.init(self, registry, targetCollection)

	if not targetCollection then
		local players = registry:findComponents("GameInfo", {gs_type="player"})
		self.targetCollection = Ring:new()
		print('PLAYERS for TCS: -> ' .. inspect(players,{depth=2}))
		for i, player in ipairs(players) do
			print('adding player ' .. player.player_name)
			self.targetCollection:add(player.player_name)
		end
	end

	local unsubEndturn= self.registry:subscribe("endTurn", function (this, msg)
		self:endTurn()
	end)
end

function TurnControlSystem:endTurn ()
	for i, player in ipairs(self.registry:findComponents("GameInfo", {gs_type="player"})) do
		player.is_current = false
	end
	print("Current player is " .. self.targetCollection:current())
	self.targetCollection:next()
	print("Changed player to " .. self.targetCollection:current())
	local current_player = self.registry:findComponent("GameInfo",{gs_type="player", player_name=self.targetCollection:current()})
	current_player.is_current = true
	self.registry:publish("beginTurn",current_player)
end

return TurnControlSystem