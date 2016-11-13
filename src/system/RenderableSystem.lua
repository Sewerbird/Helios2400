--RenderableSystem.lua

--[[
	The RenderableSystem maintains references to several game-objects, each called a Scene. 
	This facilitates the swapping of viewscreens such as different maps, interface screens, and so on. 
	The RenderableSystem draws the root game object, then its children in sequence, recursively
]]--

local System = require 'src/System'

local RenderableSystem = System:extend("RenderableSystem",{

})

function RenderableSystem:draw ()
	local function drawHeirarchy ( root )
		--Pop the coordinate system
		local delta
		if root:hasComponent('Transform') then
			delta = root:getComponent('Transform')
			love.graphics.translate(delta.x, delta.y)
		end

		--Do draw
		local renderable = root:getComponent('Renderable')
		if renderable ~= nil then
			if renderable.sprite ~= nil then
				love.graphics.draw(renderable.sprite.img, renderable.sprite.quad)
			else
				local r, g, b, a = love.graphics.getColor()
				love.graphics.setColor(renderable.backgroundcolor)
				love.graphics.setLineWidth(3)
				love.graphics.polygon('line', renderable.polygon.vertices)
				love.graphics.setColor({r,g,b,a})
			end
		end

		--Draw children
		for i, gid in ipairs(self.targetCollection:getChildren(root.uid)) do
			drawHeirarchy(self.registry:get(gid))
		end

		--Unpop the coordinate system
		if delta ~= nil then
			love.graphics.translate(-delta.x, -delta.y)
		end
	end
	drawHeirarchy(self.registry:get(self.targetCollection:getRoot()))

end

return RenderableSystem