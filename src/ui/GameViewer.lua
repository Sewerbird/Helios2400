--GameViewer
local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Queue = require 'src/structure/Queue'
local Ring = require 'src/structure/Ring'
local Stack = require 'src/structure/Stack'
local IndexTree = require 'src/structure/Stack'
local GameViewer = class("GameViewer", {
	Registry = nil,
	Systems = {},
	mapViews = nil
})

function GameViewer:init ( registry, mapViews )

	self.Registry = registry
	self.mapViews = Ring:new(mapViews)
	self:changeTo()

end

function GameViewer:changeTo ()
	self.Systems.Render = RenderableSystem:new(self.Registry, self.mapViews:current())
	self.Systems.Interface = InterfaceableSystem:new(self.Registry, self.mapViews:current())
	self.Systems.Selection = SelectableSystem:new(self.Registry, self.mapViews:current())
end

function GameViewer:draw ()
	self.mapViews:current():draw()
end

function GameViewer:update ( dt )
end

return GameViewer