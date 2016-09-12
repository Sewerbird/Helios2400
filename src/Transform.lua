--Transform.lua
local Transform = class('Transform', {
	x = 0,
	y = 0
})

function Transform:init ( x, y )
	self.x = x or 0
	self.y = y or 0
end

function Transform:translate ( dx, dy )
	self.x = self.x + dx
	self.y = self.y + dy
end

return Transform