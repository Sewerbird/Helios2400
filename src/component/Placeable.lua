--Placeable.lua

local Component = require 'src/Component'
local Placeable = Component:extend('Placeable', {
	address = nil
})

function Placeable:init ( address )
	self.address = nil
end

return Placeable