--RenderableSystem.lua
local System = require 'src/System'
local Renderable = require 'src/Renderable'

local RenderableSystem = System.extend("RenderableSystem",{
	scenes = {},
	active_scene = nil
})

function RenderableSystem:addScene ( tag, scene )
	scenes[tag] = scene
end

function RenderableSystem:setScene ( tag )
	active_scene = tag
end

function RenderableSystem:draw ()
	for i, ele in pairs(self.componentPool) do
		ele:draw()
	end
end

return RenderableSystem