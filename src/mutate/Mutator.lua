--Mutator.lua
local class = require 'lib/30log'
local Mutator = class('Mutator', {
	tgt = nil,
	old = nil
})

function Mutator:init ( target )
	self.tgt = target
	self.throwaway = false
end

function Mutator:apply ( )
end

function Mutator:rollback ( )
end

return Mutator