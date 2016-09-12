--GameObject.lua
local GameObject = class("GameObject", {
	components = {}
})

function GameObject:init ( array_components )
	if array_components ~= nil then
		for i = 1, #array_components do
			self:addComponent(array_components[i])
		end
	end
end

function GameObject:addComponent ( component )
	component.gid = self
	self.components[component.name] = component
end

function GameObject:getComponent ( type )
	return self.components[type]
end

return GameObject