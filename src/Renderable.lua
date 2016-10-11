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

return Renderable