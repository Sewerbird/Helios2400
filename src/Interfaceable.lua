--Interfaceable.lua
local Component = require 'src/Component'
local Interfaceable = Component:extend("Interfaceable", {
	name = "Interfaceable",
	children = {},
	delegate = nil,
	transform = nil,
	polygon = nil,
	current = nil
})

function Interfaceable:init ( transform, polygon, delegate)
	self.transform = transform
	self.polygon = polygon
	self.delegate = delegate
end

function Interfaceable:push ( interfaceable )
	table.insert(self.children, interfaceable)
	current = self.children[#self.children]
end

function Interfaceable:pop ()
	table.remove(self.children)
	current = self.children[#self.children]
end

function Interfaceable:receivesTouch ( x, y )
	if self.polygon:containsPoint(x - self.transform.x, y - self.transform.y) then
		return true
	end
	return false
end

function Interfaceable:onTouch ( x, y )
	if not self:receivesTouch(x,y) then return end
	local consumes = self.delegate:onTouch(x - self.transform.x, y - self.transform.y)
	if consumes then return end
	--TODO: propogate event
end

function Interfaceable:onDrag ( x, y, dx, dy )
	if not self:receivesTouch(x,y) then return end
	local consumes = self.delegate:onDrag(x - self.transform.x, y - self.transform.y, dx, dy)
	if consumes then return end
	--TODO: propogate event
end

function Interfaceable:onHover ( x, y )
	if not self:receivesTouch(x,y) then return end
	local consumes = self.delegate:onHover(x - self.transform.x, y - self.transform.y)
	if consumes then return end
	--TODO: propogate event
end

function Interfaceable:onUntouch ( x, y )
	if not self:receivesTouch(x,y) then return end
	local consumes = self.delegate:onUntouch(x - self.transform.x, y - self.transform.y)
	if consumes then return end
	--TODO: propogate event
end

function Interfaceable:onKeypress ( key )
	local consumes = self.delegate:onKeypress(key)
	if consumes then return end
	--TODO: propogate event
end

return Interfaceable