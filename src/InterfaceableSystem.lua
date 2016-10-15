--InterfaceableSystem.lua
local System = require 'src/System'
local Interfaceable = require 'src/Interfaceable'

local InterfaceableSystem = System:extend("InterfaceableSystem",{
		
})

function InterfaceableSystem:onTouch ( x, y )
	local function actEle ( obj )
		if obj:hasComponent('Interfaceable') then
			return obj:getComponent('Interfaceable'):onTouch(x, y)
		end
		return false
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onHover ( x, y )
	local function actEle ( obj )
		if obj:hasComponent('Interfaceable') then
			return obj:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
		end
		return false
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onDrag ( x, y, dx, dy )
	local function actEle ( obj )
		if obj:hasComponent('Interfaceable') then
			return obj:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
		end
		return false
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onUntouch ( x, y )
	local function actEle ( obj )
		if obj:hasComponent('Interfaceable') then
			return obj:getComponent('Interfaceable'):onUntouch(x, y)
		end
		return false
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onKeypress ( key )
	local function actEle ( obj )
		if obj:hasComponent('Interfaceable') then
			return obj:getComponent('Interfaceable'):onKeypress(key)
		end
		return false
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:depthFirstEvalLeavesFirst ( func, obj )
	for i, ele in ipairs(obj:getChildren()) do
		self:depthFirstEvalLeavesFirst(func, ele)
		if func(ele) then return end
	end
	--if func(obj) then return end
end


return InterfaceableSystem