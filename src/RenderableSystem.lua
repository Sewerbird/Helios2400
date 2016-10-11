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
	
	local function drawHeirarchy ( root )

		--Pop the coordinate system
		local delta
		if root:hasComponent('Transform') then
			delta = root:getComponent('Transform')
			love.graphics.translate(delta.x, delta.y)
		end

		--Do draw
		if root:hasComponent('Renderable') then
			local renderable = root:getComponent('Renderable')
			if renderable.sprite ~= nil then
				love.graphics.draw(renderable.sprite.img, renderable.sprite.quad)
		--else
				local r, g, b, a = love.graphics.getColor()
				love.graphics.setColor(renderable.backgroundcolor)
				love.graphics.setLineWidth(3)
				love.graphics.polygon('line', renderable.polygon.vertices)
				love.graphics.setColor({r,g,b,a})
			end
		end

		--Draw children
		for i, ele in ipairs(root:getChildren()) do
			drawHeirarchy(ele)
		end

		--Unpop the coordinate system
		if delta ~= nil and root:hasComponent('Transform') then
			love.graphics.translate(-delta.x, -delta.y)
		end
	end

	drawHeirarchy(self.rootGameObject,Transform:new(0,0))

end

return RenderableSystem