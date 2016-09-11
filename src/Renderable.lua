--Renderable.lua
local Component = require 'src/Component'
local Renderable = Component:extend("Renderable", {
	name = "Renderable",
	transform = nil,
	polygon = nil
	
})

function Renderable:init ( transform, polygon, sprite, backgroundcolor )
	self.transform = transform
	self.polygon = polygon
	self.sprite = sprite or nil
	self.backgroundcolor = backgroundcolor or {100,100,100}
end

function Renderable:draw ()
	love.graphics.setColor(self.backgroundcolor)
	love.graphics.polygon('fill', self.polygon.vertices)
end

return Renderable