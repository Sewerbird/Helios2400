--Addressable.lua

local Component = require 'src/Component'
local Addressable = Component:extend('Addressable', {
	name = 'Addressable',
	address = nil
})

function Addressable:init ( address)
	self.address = address
end

return Addressable