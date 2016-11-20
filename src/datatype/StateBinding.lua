local class = require 'lib/30log'
local StateBinding = class('StateBinding',{
	target = nil,
	topic = nil,
	fn = nil,
	unsub = nil,
	IS_LIVE = true
})

function StateBinding:init ( target, topic, fn)
	self.target = target
	self.topic = topic
	self.fn = fn

	self.unsub = Global.PubSub:subscribe(topic, function (this, msg)
		self:fn(self.target, msg)
	end)
end

function StateBinding:toString ()
	return self.column .. "_" .. self.row
end

return StateBinding