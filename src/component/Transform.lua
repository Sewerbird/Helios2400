--Transform.lua
local Component = require 'src/Component'
local Transform = Component:extend('Transform', {
	x = 0,
	y = 0
})

function Transform:init ( x, y )
	self.x = x or 0
	self.y = y or 0
end

function Transform:teleport ( x, y )
	if type(x) == 'table' then
		self.x = x.x
		self.y = x.y
	else
		self.x = x
		self.y = y
	end
end

function Transform:translateWithBounds ( dx, dy, minmaxX, minmaxY)
	self:translate(dx, dy)
	if type(minmaxX) == 'table' then
		if self.x < minmaxX[1] then self.x = minmaxX[1] end
		if self.x > minmaxX[2] then self.x = minmaxX[2] end
	end
	if type(minmaxY) == 'table' then
		if self.y < minmaxY[1] then self.y = minmaxY[1] end
		if self.y > minmaxY[2] then self.y = minmaxY[2] end
	end
end

function Transform:translate ( dx, dy )
	if type(dx) == 'table' then
		self.x = self.x + dx.x
		self.y = self.y + dx.y
	else
		self.x = self.x + dx
		self.y = self.y + dy
	end
end

function Transform:untranslate ( dx, dy )
	if type(dx) == 'table' then
		self.x = self.x - dx.x
		self.y = self.y - dx.y
	else
		self.x = self.x - dx
		self.y = self.y - dy
	end
end

return Transform