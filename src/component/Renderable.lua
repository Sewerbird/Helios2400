--Renderable.lua
local Component = require 'src/Component'
local Renderable = Component:extend("Renderable", {
	name = "Renderable",
	polygon = nil,
	sprite = nil,
	backgroundcolor = nil,
	text = nil
})

function Renderable:init ( polygon, sprite, backgroundcolor, text)
	Renderable.super.init(self)

	self:bindstate('polygon', polygon)
	self:bindstate('sprite', sprite or nil)
	self:bindstate('backgroundcolor', backgroundcolor or {math.floor(math.random() * 255),100,100})
	self:bindstate('text', text or nil)
end

return Renderable