--Stateful.lua

local Component = require 'src/Component'
local Binding = require 'src/datatype/Binding'

local Stateful = Component:extend('Stateful', {
	name = 'Stateful',
	ref = nil
})

function Stateful:init ( referent, type )
	self.ref = Binding:new(referent, type)
	self.tgt = referent
	self.type = type
end

return Stateful