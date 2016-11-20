--MutatorBus.lua
local class = require 'lib/30log'
local Queue = require 'src/structure/Queue'
local Stack = require 'src/structure/Stack'

local MutatorBus = class('MutatorBus', {
	history = Stack:new(),
	rewound = Stack:new(),
	bus = Queue:new()
})

function MutatorBus:queue ( ... )
	self.bus:push(arg)
end

function MutatorBus:queueAll( arrMut )
	self:queue(unpack(arrMut))
end

function MutatorBus:stepForward ( )
	local mutation = self.rewound:pop()
	mutation:apply()
	self.history:push(mutation)
end

function MutatorBus:stepBack ( )
	local mutation = self.history:pop()
	mutation:rollback()
	self.rewound:push(mutation)
end

function MutatorBus:playNext ()
	local mutation = self.bus:pop()
	mutation:apply()
	self.history:push(mutation)
end

function MutatorBus:playAll ()
	while self.bus:getn() > 0 do
		self:playNext()
	end
end

return MutatorBus