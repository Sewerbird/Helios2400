--InterfaceableSystem.lua
local System = require 'src/System'

local InterfaceableSystem = System:extend("InterfaceableSystem",{
	planet_width = 1512
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
	local transform = self.registry:get(iobj,'Transform')
	local inter = self.registry:get(iobj,'Interfaceable')
	local l_x = x
	local l_y = y
	local has_consumed = false
	--Push transform
	if transform then
		l_x = x - transform.x
		l_y = y - transform.y
	end
	local tl_x = l_x % self.planet_width
	--Propogate on children
	local children = self.targetCollection:getChildren(iobj)
	for i = #children, 1, -1 do
		local ele = children[i]
		has_consumed = self:propogateEvent( ele, func, tl_x, l_y, dx, dy, btn)
		if has_consumed then return true end
	end
	--Execute on self
	if inter then
		if inter[func] ~= nil and (func == 'onKeypress' or inter.polygon:containsPoint(tl_x,l_y)) then
			if func == 'onKeypress' then
				has_consumed = inter[func](inter, btn)
			else
				has_consumed = inter[func](inter,tl_x,l_y,dx,dy,btn)
			end
			if has_consumed then return true end
		end
	end
	--Pop transform
	if transform ~= nil then
		l_x = x + transform.x
		l_y = y + transform.y
	end
	return false
end


return InterfaceableSystem