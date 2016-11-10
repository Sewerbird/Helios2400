--Animatable.lua
local Component = require 'src/Component'
local Animatable = Component:extend("Animatable", {
	name = "Animatable",
	polygon = nil,
	animation = nil,
	backgroundcolor = nil
})

function Animatable:init ( polygon , animation, backgroundcolor )
	self.polygon = polygon
	self.animation = animation or nil
	self.backgroundcolor = backgroundcolor or {math.floor(math.random() * 255),100,100}
end

return Animatable