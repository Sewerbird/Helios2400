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
	font = nil
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
		if renderable.render ~= nil then
			if renderable.render.rtype == "sprite" then
				local offScreen = self:isOffScreen(renderable)
				if not offScreen then
					love.graphics.draw(renderable.render.img, renderable.render.quad)
				else 
					local mapWidth = 1512
					love.graphics.draw(renderable.render.img, renderable.render.quad, mapWidth * offScreen)
				end
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

	if cached.r == "PLZ_POP" and delta == "PLOXPOPIT" then
		love.graphics.pop()
		self.renderable_cache.translation.x:pop()
		self.renderable_cache.translation.y:pop()
	end
end

function RenderableSystem:getScreenWidthOffsets(renderable)
	local tx = (self.renderable_cache.translation.x:total() or 0) *-1
	local _, _, rw, _ = renderable.render.quad:getViewport()
	tx = tx - rw
	if tx<= 0 then return nil end
	return math.ceil(tx/ 1512)
end

function RenderableSystem:drawHeirarchy ( root, big_list )
	--Pop the coordinate system
	local delta
	if root:hasComponent('Transform') then
		delta = root:getComponent('Transform')
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

	table.insert(big_list, renderable )

	--Draw children
	for i, gid in ipairs(self.targetCollection:getChildren(root.uid)) do
		self:drawHeirarchy(self.registry:get(gid), big_list)
	end

	--Unpop the coordinate system
	if delta ~= nil then 
		love.graphics.pop() 
		table.insert(big_list, {r = "PLZ_POP", t = "PLOXPOPIT"})
	end


	return big_list
end

function RenderableSystem:draw ()
	if self.dirty > 10 then
		self.cache = self:drawHeirarchy(self.registry:get(self.targetCollection:getRoot()), {})
		self.dirty = 0
	else
		for i = 1, #self.cache do
			self:renderComponent(self.cache[i])
		end
		self.dirty = self.dirty + 1
		--if math.random() > 0.99 then self.dirty = true end
	end
end

return RenderableSystem