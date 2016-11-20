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

function Component:bindstate(field, obj, topic, fn)
	if field == nil then return end

	self[field] = obj
	
	if topic == nil or fn == nil then return end

	self["_"..field] = StateBinding:new(field, topic, fn)
end


return Component