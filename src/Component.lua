--Component.lua
local class = require 'lib/30log'
local StateBinding = require 'src/datatype/StateBinding'

local Component = class('Component', {
	gid = nil,
	gob = nil
})

function Component:init ()
end

--Called by the parent GameObject when the component is successfully added to the gameobject
function Component:onAdd ( parent )
	self.gob = parent
	self.gid = parent.uid
	self.fns = {}
end

function Component:getObject ()
	return self.gob
end

function Component:getSiblingComponent ( type )
	if self.gob:hasComponent(type) then
		return self.gob:getComponent(type)
	else
		print('could not find sibling of type ' .. type)
		return nil
	end
end

function Component:bindstate(registry, init_with, topic, fn)
	
	if registry == nil or topic == nil or fn == nil then return self end

	self["_"..self.name] = StateBinding:new(registry, self, topic, fn)

	if init_with ~= nil then
		self["_"..self.name].fn(self["_"..self.name],self,init_with)
	end

	return self
end


return Component