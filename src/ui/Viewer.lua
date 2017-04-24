--Viewer
local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Ring = require 'src/structure/Ring'
local InterfaceableSystem = require 'src/system/InterfaceableSystem'
local RenderableSystem = require 'src/system/RenderableSystem'
local SelectableSystem = require 'src/system/SelectableSystem'
local TurnControlSystem = require 'src/system/TurnControlSystem'

local UIStack = require 'lib/LoveGUI/addon/stack'
local Container = require 'lib/LoveGUI/core/container'

local TitleScreen = require 'src/gamestate/TitleScreen'

local Viewer = class("Viewer", {
	Registry = nil,
	Systems = {},
	mapViews = nil
})

function Viewer:init ( registry, mapScenes )

	self.Registry = registry

	self.Systems.TurnControl = TurnControlSystem:new(self.Registry)
	self.Systems.UIStack = UIStack.new()

	self.Systems.UIStack:push(
		TitleScreen
	)

	self.Systems.UIStack:printTree()

end

function Viewer:changeTo ()
	self.Systems.Render = self.mapViews:current().render
	self.Systems.Interface = self.mapViews:current().interface
	self.Systems.Selection = self.mapViews:current().selection
end

function Viewer:nextView ()
	self.mapViews:next()
	self:changeTo()
end

function Viewer:prevView ()
	self.mapViews:previous()
	self:changeTo()
end

function Viewer:draw ()
	self.mapViews:current():draw()
end

function Viewer:update ( dt )
	self.Registry:summarize()
end

return Viewer