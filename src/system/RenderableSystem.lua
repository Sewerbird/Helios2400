--RenderableSystem.lua

--[[
	The RenderableSystem maintains references to several game-objects, each called a Scene. 
	This facilitates the swapping of viewscreens such as different maps, interface screens, and so on. 
	The RenderableSystem draws the root game object, then its children in sequence, recursively
]]--

local System = require 'src/System'

local RenderableSystem = System:extend("RenderableSystem",{
	scenes = {},
	active_scene = nil
})

function RenderableSystem:addScene ( tag, scene )
end

function RenderableSystem:setScene ( tag )

end

function RenderableSystem:update( dt )

	local function updateHeirarchy ( root , dt)
		local animatable = root:getComponent('Animatable')
		if animatable ~= nil then
			if animatable.animation ~= nil then
				animatable.animation.ani:update(dt)
			end
		end

		--Update children
		for i, gid in ipairs(self.targetCollection:getChildren(root.uid)) do
			updateHeirarchy(self.registry:get(gid), dt)
		end
	end


	updateHeirarchy(self.registry:get(self.targetCollection:getRoot()), dt)


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
		--Renderable
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
		--Animatable
		local animatable = root:getComponent('Animatable')
		if animatable ~= nil then
			if animatable.animation ~= nil then
				animatable.animation.ani:draw(animatable.animation.sprite)--, animatable.animation.quad)
			else
				local r, g, b, a = love.graphics.getColor()
				love.graphics.setColor(animatable.backgroundcolor)
				love.graphics.setLineWidth(3)
				love.graphics.polygon('line', animatable.polygon.vertices)
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