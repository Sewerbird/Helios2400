--Placeable.lua

local Component = require 'src/Component'
local Placeable = Component:extend('Placeable', {
	name = 'Placeable',
	address = nil
})

function Placeable:init ( address )
	self.address = address
end

return Placeable