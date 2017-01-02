--RenderableSystem.lua

--[[
	The RenderableSystem maintains references to several game-objects, each called a Scene. 
	This facilitates the swapping of viewscreens such as different maps, interface screens, and so on. 
	The RenderableSystem draws the root game object, then its children in sequence, recursively
]]--

local System = require 'src/System'
local Stack = require 'src/structure/Stack'

local RenderableSystem = System:extend("RenderableSystem",{
	renderable_cache = nil,
	last_publish_count = nil,
	dirty = 10000,
	font = nil,
	planet_width = 1512
})

function RenderableSystem:init ( registry, targetCollection )
	RenderableSystem.super.init(self, registry, targetCollection)
	self.renderable_cache = {translation = {x = Stack:new(),y = Stack:new()}}
	--love.graphics.setNewFont("assets/InputSansNarrow-Light.ttf",12)
end

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

function RenderableSystem:renderComponent ( cached )
	--Pop the coordinate system
	local delta = cached.t
	if cached.r == "PLZ_PUSH" and delta then
		love.graphics.push()
		self.renderable_cache.translation.x:push(delta.x)
		self.renderable_cache.translation.y:push(delta.y)
		love.graphics.translate(delta.x, delta.y)
	end

	--Do draw
	--Renderable
	local renderable = cached
	if renderable ~= nil and cached.r ~= "PLZ_PUSH" and cached.r ~= "PLZ_POP" then
		local xOffset = (love.graphics:getWidth() < self.planet_width) and self.planet_width * self:getScreenWidthOffsets(renderable) or 0
		love.graphics.push()
		love.graphics.translate(xOffset,0)
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

				local minX = 100000000
				local maxX = -100000000
				local minY = 100000000

				for i = 1, #renderable.polygon.vertices do
					if i % 2 == 0 then
						--y
						if renderable.polygon.vertices[i] < minY then
							minY = renderable.polygon.vertices[i]
						end
					else
						--x
						if renderable.polygon.vertices[i] < minX then
							minX = renderable.polygon.vertices[i]
						elseif renderable.polygon.vertices[i] > maxX then
							maxX = renderable.polygon.vertices[i]
						end
					end
				end
				love.graphics.printf(renderable.text,
					minX, 
					minY, 
					maxX - minX,'center')
			else
				love.graphics.print(renderable.text)
			end
		end
		love.graphics.pop()
	end

	if cached.r == "PLZ_POP" and delta == "PLOXPOPIT" then
		love.graphics.pop()
		self.renderable_cache.translation.x:pop()
		self.renderable_cache.translation.y:pop()
	end
end

function RenderableSystem:getScreenWidthOffsets(renderable)
	if not renderable then return 0 end
	local tx = (self.renderable_cache.translation.x:total() or 0) *-1
	local rw = 0
	if renderable.polygon then
		rw = renderable.polygon:getDimensions().w
	elseif renderable.render then
		if renderable.render.rtype == "sprite" then 
		_, _, rw = renderable.render.quad:getViewport()
		elseif renderable.render.rtype == "animation" then
			rw = renderable.render.ani.frameWidth
		end
	end
	tx = tx - rw
	return math.ceil(tx/ self.planet_width)
end

function RenderableSystem:drawHeirarchy ( root, big_list )
	--Pop the coordinate system
	local delta
	if self.registry:get(root, "Transform") then
		delta = self.registry:get(root, "Transform")
		if delta.x == 0 and delta.y == 0 then
			delta = nil
		else
			table.insert(big_list, {r = "PLZ_PUSH", t = delta})
			love.graphics.push()
			love.graphics.translate(delta.x, delta.y)
		end
	end

	--Do draw
	--Renderable
	local renderable = self.registry:get(root, 'Renderable')
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

	table.insert(big_list, renderable )

	--Draw children
	for i, gid in ipairs(self.targetCollection:getChildren(root)) do
		self:drawHeirarchy(gid, big_list)
	end

	--Unpop the coordinate system
	if delta ~= nil then 
		love.graphics.pop() 
		table.insert(big_list, {r = "PLZ_POP", t = "PLOXPOPIT"})
	end


	return big_list
end

function RenderableSystem:draw ()
	--if self.cache == nil or self.dirty > 3 then
		--self.cache = 
		self:drawHeirarchy(self.targetCollection:getRoot(), {})
	--	self.dirty = 0
	--end

	--for i = 1, #self.cache do
	--	self:renderComponent(self.cache[i])
	--end
	--self.dirty = self.dirty + 1
end

return RenderableSystem