--GameObject.lua
local GameObject = class("GameObject", {
	uid = nil,
	components = {},
	children = {},
	parent = nil
})

function GameObject:init ( array_components )
	if array_components ~= nil then
		for i = 1, #array_components do
			self:addComponent(array_components[i])
		end
	end
end

function GameObject:setParent ( newParent )
	if self.parent ~= nil then
		self.parent:removeChild(self)
	end
	self.parent = newParent
	newParent.addChild(self)
end

function GameObject:addChild ( child )
	child.parent = self
	table.insert(self.children, child)
end

function GameObject:addChildren ( children )
	for i, child in ipairs(children) do
		self:addChild(child)
	end
end

function GameObject:removeChild ( child )
	table.remove(children, child)
end

function GameObject:getChildren ()
	return self.children
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

return GameObject