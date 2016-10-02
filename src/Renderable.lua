--Renderable.lua
local Component = require 'src/Component'
local Renderable = Component:extend("Renderable", {
	name = "Renderable",
	transform = nil,
	polygon = nil,
	sprite = nil
	
})

function Renderable:init ( polygon, sprite, backgroundcolor )
	self.polygon = polygon
	self.sprite = sprite or nil
	self.backgroundcolor = backgroundcolor or {math.floor(math.random() * 255),100,100}
end

function Renderable:onAdd ( parent )
	Renderable.super.onAdd(self,parent)
	self.transform = self:getSiblingComponent('Transform')
end

function Renderable:draw ()
	love.graphics.translate(self.transform.x, self.transform.y)

	if self.sprite ~= nil then
		love.graphics.draw(self.sprite.img, self.sprite.quad)
	end

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.backgroundcolor)
	love.graphics.setLineWidth(3)
	love.graphics.polygon('line', self.polygon.vertices)
	love.graphics.setColor({r,g,b,a})


	love.graphics.translate(-self.transform.x, -self.transform.y)
end

return Renderable