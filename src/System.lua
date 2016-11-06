--System.lua
local class = require 'lib/30log'
local System = class("System",{
	componentPool = {},
	targetColletion = nil
})

function System:init ( targetCollection )
	self.targetCollection = targetCollection
end


return System