--Viewer
local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Ring = require 'src/structure/Ring'
local InterfaceableSystem = require 'src/system/InterfaceableSystem'
local RenderableSystem = require 'src/system/RenderableSystem'
local SelectableSystem = require 'src/system/SelectableSystem'
local TurnControlSystem = require 'src/system/TurnControlSystem'

local GameObject = require 'src/GameObject'
local ElementWrapper = require 'src/component/ElementWrapper'
local UIStack = require 'lib/LoveGUI/addon/stack'
local Container = require 'lib/LoveGUI/core/container'
local MapViewElement = require 'src/ui/mapViewElement'

local Viewer = class("Viewer", {
	Registry = nil,
	Systems = {},
	mapViews = nil
})

function Viewer:init ( registry, mapScenes )

	self.Registry = registry

	self.Systems.TurnControl = TurnControlSystem:new(self.Registry)
	self.Systems.UIStack = UIStack.new()

	local mapPositioner = Container.new('MAP_VIEW_POSITIONER',{
		visible = false,
		alignment = 'right'
	}):addElement(MapViewElement.new())
	local mapViewObject = GameObject:new('MAP_VIEW',{
		ElementWrapper:new(mapViewElement)
	},Global.Registry)

	self.Systems.UIStack:push(
		mapPositioner
	)

	self.mapViews = Ring:new()
	for i, scene in ipairs(mapScenes) do
		local view = {
			sceneGraph = scene,
			render = RenderableSystem(self.Registry,scene),
			interface = InterfaceableSystem(self.Registry,scene),
			selection = SelectableSystem(self.Registry,scene, "ANIM_CURSOR_1")
		}
		self.mapViews:add(view)
	end
	self:changeTo()

	self.Systems.TurnControl:begin()

	registry:subscribe("ui/debug_prevscene", function() 
		self:prevView() 
	end)

	registry:subscribe("ui/debug_nextscene", function()
		self:nextView()
	end)

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