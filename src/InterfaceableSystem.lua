--InterfaceableSystem.lua
local System = require 'src/System'
local Interfaceable = require 'src/Interfaceable'

local InterfaceableSystem = System:extend("InterfaceableSystem",{
		
})

function InterfaceableSystem:onTouch(x, y)
	local function actEle( obj )
		if obj:hasComponent('Interfaceable') then
			obj:getComponent('Interfaceable'):onTouch(x, y)
		end
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onHover(x, y)
	local function actEle( obj )
		if obj:hasComponent('Interfaceable') then
			obj:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
		end
	end
	print('on hovering at ' .. x .. ',' .. y)
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onDrag(x, y, dx, dy)
	local function actEle( obj )
		if obj:hasComponent('Interfaceable') then
			obj:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
		end
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onUntouch(x, y)
	local function actEle( obj )
		if obj:hasComponent('Interfaceable') then
			obj:getComponent('Interfaceable'):onUntouch(x, y)
		end
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end

function InterfaceableSystem:onKeypress(key)
	local function actEle( obj )
		if obj:hasComponent('Interfaceable') then
			obj:getComponent('Interfaceable'):onKeypress(key)
		end
	end
	self:depthFirstEvalLeavesFirst( actEle, self.rootGameObject)
end


return InterfaceableSystem