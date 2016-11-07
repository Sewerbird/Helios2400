--Addressable.lua

local Component = require 'src/Component'
local Addressable = Component:extend('Addressable', {
	name = 'Addressable',
	neighbors = nil,
	uid = nil
})

function Addressable:init ( uid, neighbors)
	self.neighbors = neighbors
	self.uid = uid

	self:neighborsValid()
end

function Addressable:neighborsValid()
	for i, v in ipairs(self.neighbors) do
		if v == self.uid then
			error 'Tried to create addressable as its own neighbor'
		end
	end
	return true
end

return Addressable