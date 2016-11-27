--Component.lua
local class = require 'lib/30log'

local Component = class('Component', {
	gid = nil,
	gob = nil,
	deferred_bindings = {}
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

function Component:bindTo( topic, fn, init_with )
	if self.registry ~= nil then
		if self.gob.registry == nil or topic == nil or fn == nil then 
			error('Trying to bind ' .. self.name .. ' without required arguments...')
		end
		self.registry:bind(self, topic, fn, init_with)
	else
		table.insert(self.deferred_bindings,{topic = topic, fn = fn, init_with = init_with})
	end

	return self
end

return Component