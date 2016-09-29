--RenderableSystem.lua

--[[
	The RenderableSystem maintains references to several game-objects, each called a Scene. 
	This facilitates the swapping of viewscreens such as different maps, interface screens, and so on. 
	The RenderableSystem draws the root game object, then its children in sequence, recursively
]]--

local System = require 'src/System'
local Renderable = require 'src/Renderable'

local RenderableSystem = System:extend("RenderableSystem",{
	scenes = {},
	active_scene = nil
})

function RenderableSystem:addScene ( tag, scene )
	self.scenes[tag] = scene
end

function RenderableSystem:setScene ( tag )
	self.active_scene = tag
	self.rootGameObject = self.scenes[self.active_scene]
end

function RenderableSystem:draw ()
	local function drawEle( obj )
		if obj:hasComponent('Renderable') then
			obj:getComponent('Renderable'):draw()
		end
	end
	self:depthFirstEvalRootFirst( drawEle, self.rootGameObject)
end

return RenderableSystem