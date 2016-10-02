--Component.lua
local Component = class('Component', {
	gid = nil,
	gob = nil
})

function Component:init ()
end

function Component:onAdd ( parent )
	self.gob = parent
	self.gid = parent.uid
end

function Component:getObject ()
	return gid
end

function Component:getSiblingComponent (type)
	if self.gob:hasComponent(type) then
		return self.gob:getComponent(type)
	else
		print('could not find sibling of type ' .. type)
		return nil
	end
end

return Component