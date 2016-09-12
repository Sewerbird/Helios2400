--Renderable.lua
local Component = require 'src/Component'
local Renderable = Component:extend("Renderable", {
	name = "Renderable",
	transform = nil,
	polygon = nil,
	sprite = nil
	
})

function Renderable:init ( transform, polygon, sprite, backgroundcolor )
	self.transform = transform
	self.polygon = polygon
	self.sprite = sprite or nil
	self.backgroundcolor = backgroundcolor or {100,100,100}
end

function Renderable:draw ()
	love.graphics.translate(self.transform.x, self.transform.y)

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.backgroundcolor)
	love.graphics.polygon('fill', self.polygon.vertices)
	love.graphics.setColor({r,g,b,a})

	if self.sprite ~= nil then
		love.graphics.draw(self.sprite.img, self.sprite.quad)
	end

	love.graphics.translate(-self.transform.x, -self.transform.y)
end

return Renderable