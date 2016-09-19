--System.lua
local System = class("System",{
	componentPool = {}
})

function System:addComponent ( component )
	componentPool[component.gid] = component
end

function System:removeComponentByGameObjectId ( component_gid )
	componentPool[component.gid] = nil
end

return System