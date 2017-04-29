local Container = require 'lib/LoveGUI/core/container'
local Button = require 'lib/LoveGUI/core/button'
local Text = require 'lib/LoveGUI/core/text'

local Ring = require 'src/structure/Ring'

local MapViewElement = require 'src/ui/mapViewElement'
local GameObject = require 'src/GameObject'
local ElementWrapper = require 'src/component/ElementWrapper'
local InterfaceableSystem = require 'src/system/InterfaceableSystem'
local RenderableSystem = require 'src/system/RenderableSystem'
local SelectableSystem = require 'src/system/SelectableSystem'

local Game = class("Game", {
	Registry = nil,
	mapViews = nil,
	viewer = nil
})

function Game:init (viewer, registry, mapScenes)
	self.Viewer = viewer
	self.Registry = registry
	self.GameWrapper = Container.new('MAP_VIEW_POSITIONER',{
			visible = false,
			alignment = 'right'
	}):addElement(MapViewElement.new())

	local mapViewObject = GameObject:new('MAP_VIEW',{
		ElementWrapper:new(mapViewElement)
	},Global.Registry)

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

	self.Viewer.Systems.TurnControl:begin()

	--self.Viewer.Systems.UIStack:push(GameWrapper)

	registry:subscribe("ui/debug_prevscene", function() 
		self:prevView() 
	end)

	registry:subscribe("ui/debug_nextscene", function()
		self:nextView()
	end)
end

function Game:changeTo ()
	self.Viewer.Systems.Render = self.mapViews:current().render
	self.Viewer.Systems.Interface = self.mapViews:current().interface
	self.Viewer.Systems.Selection = self.mapViews:current().selection
end

function Game:nextView ()
	self.mapViews:next()
	self:changeTo()
end

function Game:prevView ()
	self.mapViews:previous()
	self:changeTo()
end

function Game:draw ()
	self.mapViews:current():draw()
end

function Game:update ( dt )
	self.Registry:summarize()
end

return Game