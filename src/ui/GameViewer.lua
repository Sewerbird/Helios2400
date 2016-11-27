--GameViewer
local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Ring = require 'src/structure/Ring'
local InterfaceableSystem = require 'src/system/InterfaceableSystem'
local RenderableSystem = require 'src/system/RenderableSystem'
local SelectableSystem = require 'src/system/SelectableSystem'

local GameViewer = class("GameViewer", {
	Registry = nil,
	Systems = {},
	mapViews = nil
})

function GameViewer:init ( registry, mapScenes )

	self.Registry = registry
	self.mapViews = Ring:new()
	for i, scene in ipairs(mapScenes) do
		local view = {
			sceneGraph = scene,
			render = RenderableSystem:new(self.Registry, scene),
			interface = InterfaceableSystem:new(self.Registry, scene),
			selection = SelectableSystem:new(self.Registry, scene, "CURSOR_1")
		}
		self.mapViews:add(view)
	end
	self:changeTo()

end

function GameViewer:changeTo ()
	self.Systems.Render = self.mapViews:current().render
	self.Systems.Interface = self.mapViews:current().interface
	self.Systems.Selection = self.mapViews:current().selection
end

function GameViewer:nextView ()
	print('next!')
	self.mapViews:next()
	self:changeTo()
end

function GameViewer:draw ()
	self.mapViews:current():draw()
end

function GameViewer:update ( dt )
	self.Registry:summarize()
end

return GameViewer