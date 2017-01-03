--Component.lua
local class = require 'lib/30log'

local Component = class('Component', {
	gid = nil,
	gob = nil,
	deferred_bindings = {}
})

function Component:init ()
end

function Component:link ( gid )
end

function Component:bindTo( topic, fn, init_with )
	if self.registry ~= nil then
		self.registry:bind(self, topic, fn, init_with)
	else
		table.insert(self.deferred_bindings,{topic = topic, fn = fn, init_with = init_with})
	end

	return self
end

return Component