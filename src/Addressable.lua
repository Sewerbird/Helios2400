--Addressable.lua

local Component = require 'src/Component'
local Addressable = Component:extend('Addressable', {
	neighbors = nil,
	idx = nil
})

function Addressable:init ( idx, neighbors)
	self.neighbors = neighbors
	self.idx = idx
end

return Addressable