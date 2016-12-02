--Addressable.lua

local Component = require 'src/Component'
local Addressable = Component:extend('Addressable', {
	name = 'Addressable',
	address = nil,
	map = nil
})

function Addressable:init ( address, map)
	self.address = address
	self.map = map
end

return Addressable