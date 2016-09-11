--Transform.lua
local Transform = class('Transform', {
	x = 0,
	y = 0,
	parent = nil,
	children = nil
})

function Transform:init ()

end

function Transform:translate (dx, dy)
	self.x += dx
	self.y += dy
end

function Transform:addChild(transform)
	if children == nil then
		children = {}
	end
	table.insert(children, transform)
end

function Transform:

return Transform