--GameObject.lua
local class = require 'lib/30log'
local GameObject = class("GameObject", {
	uid = nil,
	components = {},
	description = ''
})

function GameObject:init ( description, array_components, systems_to_register )
	self.description = description
	if array_components ~= nil then
		for i = 1, #array_components do
			self:addComponent(array_components[i])
		end
	end
end

function deprecation_guard(type)
	if type == "Placeable" then error("Tried to access a placeable object") end
	if type == "Addressable" then error("Tried to access an addressable object") end
	if type == "Moveable" then error("Tried to access a moveable object") end
end

function GameObject:hasComponent ( type )
	deprecation_guard(type)
	return self.components[type] ~= nil
end

function GameObject:addComponent ( component )
	component.gid = self.uid
	component.gob = self
	self.components[component.name] = component
	if component.onAdd ~= nil then
		component:onAdd(self)
	end
end

function GameObject:getComponent ( type )
	deprecation_guard(type)
	return self.components[type]
end

function GameObject:getComponents ()
	return self.components
end

function GameObject:getInfo()
	local result = "{" .. self.description .. "}["
	for k,v in pairs(self.components) do
		result = result .. "(" .. (k or "nil") .. ")"
	end
	return result .. "]"
end

function GameObject:__tostring()
	local result = self.description or "undefinedGameObject"
	result = result .. "["
	for k,v in pairs(self:getComponents()) do
		result = result .. k ..","
	end
	result = result:sub(1, -2)
	return result .. "]"
end

return GameObject