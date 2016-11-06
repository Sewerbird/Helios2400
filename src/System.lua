--System.lua
local class = require 'lib/30log'
local System = class("System",{
	componentPool = {},
	targetColletion = nil,
	registry = nil
})

function System:init ( registry, targetCollection )
	self.targetCollection = targetCollection
	self.registry = registry
end


return System