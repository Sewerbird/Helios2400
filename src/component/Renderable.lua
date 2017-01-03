--Renderable.lua
local Component = require 'src/Component'
local Renderable = Component:extend("Renderable", {
	name = "Renderable",
	polygon = nil,
	render = nil,
	backgroundcolor = nil,
	text = nil
})

function Renderable:init ( polygon, render, backgroundcolor, text)
	Renderable.super.init(self)
	self.polygon = polygon
	self.render = render or nil
	self.backgroundcolor = backgroundcolor or {math.floor(math.random() * 255),100,100,125}
	self.text = text or nil
end

function Renderable:onFinalized(this, registry)
	if self.render and self.render.rtype == "animation" then
		registry:subscribe("tick", function(this, msg)
			self.render.ani:update(msg.dt)
		end)
	end
end

return Renderable