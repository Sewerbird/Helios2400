--Addressable.lua

local Component = require 'src/Component'
local Addressable = Component:extend('Addressable', {
	name = 'Addressable',
	neighbors = nil,
	idx = nil
})

function Addressable:init ( idx, neighbors)
	self.neighbors = neighbors
	self.idx = idx

	self:neighborsValid()
end

function Addressable:neighborsValid()
	for i, v in ipairs(self.neighbors) do
		if v == self.idx then
			error 'Tried to create addressable as its own neighbor'
		end
	end
	return true
end

return Addressable