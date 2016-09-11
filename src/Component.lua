--Component.lua
local Component = class('Component', {
	gid = nil
})

function Component:init ()
end

function Component:getObject ()
	return gid
end

return Component