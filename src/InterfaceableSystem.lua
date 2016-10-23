--InterfaceableSystem.lua
local System = require 'src/System'
local Interfaceable = require 'src/Interfaceable'

local InterfaceableSystem = System:extend("InterfaceableSystem",{
		
})

function InterfaceableSystem:onTouch ( x, y )
	self:propogateEvent(self.rootGameObject, 'onTouch', x, y)
end

function InterfaceableSystem:onHover ( x, y )
	self:propogateEvent(self.rootGameObject, 'onDrag', x, y)
end

function InterfaceableSystem:onDrag ( x, y, dx, dy )
	self:propogateEvent(self.rootGameObject, 'onDrag', x, y, dx, dy)
end

function InterfaceableSystem:onUntouch ( x, y )
	self:propogateEvent(self.rootGameObject, 'onUntouch', x, y)
end

function InterfaceableSystem:onKeypress ( key )
	self:propogateEvent(self.rootGameObject, 'onKeypress', nil, nil, nil, nil, key)
end

function InterfaceableSystem:propogateEvent ( obj, func, x, y, dx, dy, btn )
	local transform = nil
	local l_x = x
	local l_y = y
	--Push transform
	if obj:hasComponent('Transform') then
		transform = obj:getComponent('Transform')
		l_x = x - transform.x
		l_y = y - transform.y
	end
	--Execute on self
	if obj:hasComponent('Interfaceable') then
		local inter = obj:getComponent('Interfaceable')
		if inter[func] ~= nil and inter.polygon:containsPoint(l_x,l_y) then
			inter[func](inter,x,y,dx,dy,btn)
		end
	end
	--Propogate on children
	for i, ele in ipairs(obj:getChildren()) do
		self:propogateEvent( ele, func, l_x, l_y, dx, dy, btn)
	end
	--Pop transform
	if transform ~= nil then
		l_x = x + transform.x
		l_y = y + transform.y
	end
end


return InterfaceableSystem