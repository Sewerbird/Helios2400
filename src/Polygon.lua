--Clickspace Polygon
local class = require 'lib/30log'
local Polygon = class('Polygon', {
	vertices = { 0,0 , 10,0 , 5,10 },
	w = 10,
	h = 5,
	num_vertices = 3
})

function Polygon:init ( vertices )
	if not vertices then
		error 'Tried to create a polygon without vertices'
	end

	--polygon initialization with a vertex list
	if vertices and #vertices > 2 then
		self.vertices = vertices
	--convenience rectangular overload to allow ({x = 0, y = 0} {w = width, h = height}) intiialization
	else
		self.vertices = {
			0,0 , 
			vertices.w,0 , 
			vertices.w,vertices.h, 
			0,vertices.h
		}
	end
	local isX = true
	local minX = 0
	local maxX = 0
	local minY = 0
	local maxY = 0
	for i = 1, #self.vertices do
		local v = self.vertices[i]
		if isX then
			if v < minX then
				minX = v
			end
			if v > maxX then
				maxX = v
			end
		else
			if v < minY then
				minY = v
			end
			if v > maxY then
				maxY = v
			end
		end
		isX = not isX
	end

	self.w = maxX - minX
	self.h = maxY - minY
	self.num_vertices = #self.vertices/2
end

function Polygon:containsPoint ( q_x, q_y )
	return self:coordInAABB(q_x, q_y) and self:coordInPoly(q_x, q_y)
end

function Polygon:coordInAABB ( q_x, q_y )
	return q_x > 0 and q_x < self.w and q_y > 0 and q_y < self.h
end

function Polygon:coordInPoly ( q_x, q_y )
	if not self:coordInAABB(q_x, q_y) then return false end

	local a = self.num_vertices
	local result = false

	for b = 1, self.num_vertices do
		local s = self:getVertex(a)
		local e = self:getVertex(b)

		if ((e.y > q_y) ~= (s.y > q_y)) and (q_x < (s.x - e.x) * (q_y - e.y) / (s.y - e.y) + e.x) then
			result = not result
		end
		a = b
	end

	return result
end

function Polygon:getVertex ( idx )
	return {
		x = self.vertices[((idx - 1) * 2) + 1],
		y = self.vertices[((idx - 1) * 2) + 2]
	}
end

return Polygon
