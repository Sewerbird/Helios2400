--InterfaceableSystem.lua
local System = require 'src/System'
local Interfaceable = require 'src/Interfaceable'

local InterfaceableSystem = System:extend("InterfaceableSystem",{
		
})

function InterfaceableSystem:onTouch ( x, y )
	self:propogateEvent(self.targetCollection:getRoot(), 'onTouch', x, y)
end

function InterfaceableSystem:onHover ( x, y )
	self:propogateEvent(self.targetCollection:getRoot(), 'onDrag', x, y)
end

function InterfaceableSystem:onDrag ( x, y, dx, dy )
	self:propogateEvent(self.targetCollection:getRoot(), 'onDrag', x, y, dx, dy)
end

function InterfaceableSystem:onUntouch ( x, y )
	self:propogateEvent(self.targetCollection:getRoot(), 'onUntouch', x, y)
end

function InterfaceableSystem:onKeypress ( key )
	self:propogateEvent(self.targetCollection:getRoot(), 'onKeypress', 0, 0, 0, 0, key)
end

function InterfaceableSystem:propogateEvent ( iobj, func, x, y, dx, dy, btn )
	local transform = nil
	local l_x = x
	local l_y = y
	local has_consumed = false
	local obj = Global.Registry:get(iobj)
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
			has_consumed = inter[func](inter,x,y,dx,dy,btn)
			if has_consumed then return true end
		end
	end
	--Propogate on children
	local children = self.targetCollection:getChildren(iobj)
	for i = #children, 1, -1 do
		local ele = children[i]
		has_consumed = self:propogateEvent( ele, func, l_x, l_y, dx, dy, btn)
		if has_consumed then return true end
	end
	--Pop transform
	if transform ~= nil then
		l_x = x + transform.x
		l_y = y + transform.y
	end
	return false
end


return InterfaceableSystem