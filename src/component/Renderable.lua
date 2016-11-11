--Renderable.lua
local Component = require 'src/Component'
local Renderable = Component:extend("Renderable", {
	name = "Renderable",
	polygon = nil,
	render = nil,
	backgroundcolor = nil
})

function Renderable:init ( polygon, render, backgroundcolor )
	self.polygon = polygon
	self.render = render or nil
	self.backgroundcolor = backgroundcolor or {math.floor(math.random() * 255),100,100}
end

return Renderable