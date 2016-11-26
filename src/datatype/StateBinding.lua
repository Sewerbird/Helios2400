local class = require 'lib/30log'
local StateBinding = class('StateBinding',{
	target = nil,
	topic = nil,
	fn = nil,
	unsub = nil,
	IS_LIVE = true
})

function StateBinding:init ( registry, target, topic, fn)
	self.registry = registry
	self.target = target
	self.topic = topic
	self.fn = fn

	self.unsub = registry:subscribe(topic, function (this, msg)
		self:fn(self.target, msg)
	end)
end

function StateBinding:toString ()
	return self.column .. "_" .. self.row
end

return StateBinding