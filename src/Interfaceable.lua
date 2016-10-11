--Interfaceable.lua
local Component = require 'src/Component'
local Interfaceable = Component:extend("Interfaceable", {
	name = "Interfaceable",
	delegate = nil,
	transform = nil,
	polygon = nil,
	current = nil
})

function Interfaceable:init ( polygon, delegate )
	self.polygon = polygon
	self.delegate = delegate
end

function Interfaceable:onAdd ( parent )
	Interfaceable.super.onAdd(self, parent)
	self.transform = self:getSiblingComponent('Transform')
end

function Interfaceable:receivesTouch ( x, y )
	if self.polygon:containsPoint(x - self.transform.x, y - self.transform.y) then
		return true
	end
	return false
end

function Interfaceable:onTouch ( x, y )
	if not self:receivesTouch(x,y) then return end
	self.delegate:onTouch(x - self.transform.x, y - self.transform.y)
end

function Interfaceable:onDrag ( x, y, dx, dy )
	if not self:receivesTouch(x,y) then return end
	self.delegate:onDrag(x - self.transform.x, y - self.transform.y, dx, dy)
end

function Interfaceable:onHover ( x, y )
	if not self:receivesTouch(x,y) then return end
	self.delegate:onHover(x - self.transform.x, y - self.transform.y)
end

function Interfaceable:onUntouch ( x, y )
	if not self:receivesTouch(x,y) then return end
	self.delegate:onUntouch(x - self.transform.x, y - self.transform.y)
end

function Interfaceable:onKeypress ( key )
	self.delegate:onKeypress(key)
end

return Interfaceable