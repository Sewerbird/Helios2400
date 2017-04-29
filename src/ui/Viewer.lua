--Viewer
local class = require 'lib/30log'
local inspect = require 'lib/inspect'

local UIStack = require 'lib/LoveGUI/addon/stack'
local Container = require 'lib/LoveGUI/core/container'

local Game = require 'src/gamestate/Game'
local TitleScreen = require 'src/gamestate/TitleScreen'
local TurnControlSystem = require 'src/system/TurnControlSystem'

local Viewer = class("Viewer", {
	Systems = {},
	game = nil
})

function Viewer:init (registry, mapScenes )
	self.Systems.UIStack = UIStack.new()
	self.Systems.TurnControl = TurnControlSystem:new(registry)

	self.Systems.UIStack:push(
		TitleScreen
	)
	self.game = Game:new(self, registry, mapScenes)
	self.Systems.UIStack:printTree()

end

return Viewer