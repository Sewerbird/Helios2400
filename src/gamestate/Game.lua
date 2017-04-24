local Container = require 'lib/LoveGUI/core/container'
local Button = require 'lib/LoveGUI/core/button'
local Text = require 'lib/LoveGUI/core/text'

local MapViewElement = require 'src/ui/mapViewElement'
local GameObject = require 'src/GameObject'
local ElementWrapper = require 'src/component/ElementWrapper'

local TitleScreen = Container.new('MAP_VIEW_POSITIONER',{
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

return TitleScreen