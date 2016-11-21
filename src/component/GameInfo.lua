--GameInfo.lua

local Component = require 'src/Component'
local GameInfo = Component:extend('GameInfo', {
	name = 'GameInfo'
})

function GameInfo:init ( state )
	for key, value in pairs( state ) do
		self[key] = value
	end
end

return GameInfo