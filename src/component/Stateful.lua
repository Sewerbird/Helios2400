--Stateful.lua

local Component = require 'src/Component'
local Stateful = Component:extend('Stateful', {
	name = 'Stateful',
	ref = nil
})

function Stateful:init ( referent )
	self.ref = referent
end

return Stateful