--MutatorBus.lua
local class = require 'lib/30log'
local Queue = require 'src/structure/Queue'
local Stack = require 'src/structure/Stack'

local MutatorBus = class('MutatorBus', {
	gamestate = nil,
	history = Stack:new(),
	rewound = Stack:new(),
	bus = Queue:new()
})

function MutatorBus:init (state)
	self.gamestate = state
	self.bus = Queue:new()
	self.rewound = Stack:new()
	self.history = Stack:new()

	Global.PubSub:subscribe("IMMEDIATE_MUTATE", function (this, msg)
		self:queue(msg)
		self:playAll()
	end)
end

function MutatorBus:queue ( mut )
	self.bus:push(mut)
end

function MutatorBus:queueAll( arrMut )
	for i = 1, #arrMut do
		self:queue(arrMut[i])
	end
end

function MutatorBus:stepForward ( )
	local mutation = self.rewound:pop()
	mutation:apply()
	self.history:push(mutation)
end

function MutatorBus:stepBack ( )
	local mutation = self.history:pop()
	mutation:rollback(self.gamestate, Global.PubSub)
	self.rewound:push(mutation)
end

function MutatorBus:playNext ()
	local mutation = self.bus:pop()
	mutation:apply(self.gamestate, Global.PubSub)
	self.history:push(mutation)
end

function MutatorBus:playAll ()
	while self.bus:getn() > 0 do
		self:playNext()
	end
end

return MutatorBus