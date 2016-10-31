--GameObject.lua
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

function GameObject:hasComponent ( type )
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
	return self.components[type]
end

function GameObject:getComponents ()
	return self.components
end

return GameObject