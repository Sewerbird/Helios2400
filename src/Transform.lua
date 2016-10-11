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
		self.x = self.x + dx.x
		self.y = self.y - dx.y
	else
		self.x = self.x - dx
		self.y = self.y - dy
	end
end

return Transform