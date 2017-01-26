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
local MainMenu = require 'src/ui/MainMenu'
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

	local menuViewObject = GameObject:new('MAIN_MENU',{
		ElementWrapper:new(MainMenu)
	},Global.Registry)
	local mapPositioner = Container.new('MAP_VIEW_POSITIONER',{
		visible = false,
		alignment = 'right'
	}):addElement(MapViewElement)
	local mapViewObject = GameObject:new('MAP_VIEW',{
		ElementWrapper:new(mapViewElement)
	},Global.Registry)

	self.Systems.UIStack:push(
		mapPositioner
	)
	self.Systems.UIStack:push(
		MainMenu
	)

	self.mapViews = Ring:new()
	for i, scene in ipairs(mapScenes) do
		local view = {
			RS = RenderableSystem(Global.Registry,scene)
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

end

function Viewer:changeTo ()
	self.Systems.RS = self.mapViews:current().RS
	--self.Systems.Interface = self.mapViews:current().interface
	--self.Systems.Selection = self.mapViews:current().selection
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