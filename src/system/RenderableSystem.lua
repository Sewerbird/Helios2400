--RenderableSystem.lua

--[[
	The RenderableSystem maintains references to several game-objects, each called a Scene. 
	This facilitates the swapping of viewscreens such as different maps, interface screens, and so on. 
	The RenderableSystem draws the root game object, then its children in sequence, recursively
]]--

local System = require 'src/System'

local RenderableSystem = System:extend("RenderableSystem",{

})

function RenderableSystem:update( dt )

	local function updateHeirarchy ( root , dt)
		local renderable = root:getComponent('Renderable')
		if renderable ~= nil then
			if renderable.render ~= nil then
				if renderable.render.rtype == "animation" then
					renderable.render.ani:update(dt)
				end
			end
		end

		--Update children
		for i, gid in ipairs(self.targetCollection:getChildren(root.uid)) do
			updateHeirarchy(self.registry:get(gid), dt)
		end
	end

	updateHeirarchy(self.registry:get(self.targetCollection:getRoot()), dt)

end

function RenderableSystem:drawHeirarchy ( root )
	--Pop the coordinate system
	local delta
	if root:hasComponent('Transform') then
		delta = root:getComponent('Transform')
		love.graphics.push()
		love.graphics.translate(delta.x, delta.y)
	end

	--Do draw
	--Renderable
	local renderable = root:getComponent('Renderable')
	if renderable ~= nil then
		if renderable.render ~= nil then
			if renderable.render.rtype == "sprite" then
				love.graphics.draw(renderable.render.img, renderable.render.quad)
			elseif renderable.render.rtype == "animation" then
				renderable.render.ani:draw(renderable.render.sprite)
			end
		elseif renderable.polygon ~= nil then
			local r, g, b, a = love.graphics.getColor()
			love.graphics.setColor(renderable.backgroundcolor)
			love.graphics.setLineWidth(3)
			local tris = love.math.triangulate(renderable.polygon.vertices)
			for i, v in ipairs(tris) do
				love.graphics.polygon('fill', v)
			end
			love.graphics.setColor({r,g,b,a})
		end
		if renderable.text ~= nil then
			if renderable.polygon then
				love.graphics.printf(renderable.text,
					renderable.polygon.vertices[1], 
					renderable.polygon.vertices[2], 
					renderable.polygon.vertices[3],'center')
			else
				love.graphics.print(renderable.text)
			end
		end
	end

	--Draw children
	for i, gid in ipairs(self.targetCollection:getChildren(root.uid)) do
		self:drawHeirarchy(self.registry:get(gid))
	end

	--Unpop the coordinate system
	if delta ~= nil then love.graphics.pop() end
end

function RenderableSystem:draw ()
	self:drawHeirarchy(self.registry:get(self.targetCollection:getRoot()))
end

return RenderableSystem