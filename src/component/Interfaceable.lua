--Interfaceable.lua
local Component = require 'src/Component'
local Interfaceable = Component:extend("Interfaceable", {
	name = "Interfaceable",
	delegate = nil,
	--transform = nil,
	polygon = nil,
	current = nil
})

function Interfaceable:init ( polygon, delegate )
	self.polygon = polygon
	self.delegate = delegate

	if not delegate then
		error 'Tried to create Interfaceable without a delegate'
	end
	
	self.delegate.component = self
end

function Interfaceable:onAdd ( parent )
	Interfaceable.super.onAdd(self, parent)
	--self.transform = self:getSiblingComponent('Transform')
end

function Interfaceable:receivesTouch ( x, y )
	return self.polygon:containsPoint( x, y ) 
	--return self.polygon:containsPoint(x - self.transform.x, y - self.transform.y)
end

function Interfaceable:onTouch ( x, y )
	return self.polygon:containsPoint( x, y ) and self.delegate:onTouch(x, y) or false
end

function Interfaceable:onDrag ( x, y, dx, dy )
	return self.polygon:containsPoint( x, y ) and self.delegate:onDrag(x, y, dx, dy) or false
end

function Interfaceable:onHover ( x, y )
	return self.polygon:containsPoint( x, y ) and self.delegate:onHover(x, y) or false
end

function Interfaceable:onUntouch ( x, y )
	return self.polygon:containsPoint( x, y ) and self.delegate:onUntouch(x, y) or false
end

function Interfaceable:onKeypress ( key )
	return self.delegate:onKeypress(key)
end

return Interfaceable