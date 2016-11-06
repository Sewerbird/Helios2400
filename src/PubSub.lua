--PubSub.lua
local class = require 'lib/30log'
local PubSub = class('PubSub', {
	UID_CNTR = 0,
	topics = {}
})

function PubSub:subscribe( topic, callback )
	if self.topics[topic] == nil then
	  self.topics[topic] = {}
	end
	local f = self.UID_CNTR + 1
	table.insert(self.topics[topic],{
	  uid = f,
	  cb = callback
	})
	--return an unsubscribe function
	return function ()
	  for i, v in ipairs(self.topics[topic]) do
	    if v.uid == f then
	      table.remove(v)
	    end
	  end
	end
end

function PubSub:publish( topic, message )
	if self.topics[topic] == nil then return end

	for i, v in ipairs(self.topics[topic]) do
	  v.cb(message)
	end
end

return PubSub