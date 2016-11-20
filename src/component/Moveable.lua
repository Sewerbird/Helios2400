--Moveable.lua

local Component = require 'src/Component'
local Moveable = Component:extend('Moveable', {
	name = 'Moveable'
})

function Moveable:init ( address )

end

return Moveable