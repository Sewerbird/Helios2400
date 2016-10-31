--System.lua
local System = class("System",{
	componentPool = {},
	targetColletion = nil
})

function System:init ( targetCollection )
	self.targetCollection = targetCollection
end


return System