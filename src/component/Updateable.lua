--Updateable.lua

local Component = require 'src/Component'
local Updateable = Component:extend('Updateable', {
	name = 'Updateable',
	subscriptions = {}
})

function Updateable:init ( subscriptions )
	for topic, fn in pairs(subscriptions) do
		subscriptions[topic] = Global.PubSub:subscribe(topic, function (this, message) 
			fn(self, message)
		end)
	end
end

return Updateable