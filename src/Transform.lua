--Transform.lua
local Transform = class('Transform', {
	x = 0,
	y = 0,
	parent = nil,
	children = nil
})

function Transform:init ( x,y )
	self.x = x
	self.y = y
end

function Transform:translate (dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

return Transform