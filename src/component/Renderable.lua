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
	self.polygon = polygon
	self.sprite = sprite or nil
	self.backgroundcolor = backgroundcolor or {math.floor(math.random() * 255),100,100}
	self.text = text or nil
end

return Renderable