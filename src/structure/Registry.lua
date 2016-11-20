--Registry.lua
local class = require 'lib/30log'
local Registry = class('Registry', {
	registry = {},
	historicCounter = 1
})

function Registry:init ( )
end

function Registry:add ( tgtObject )
	assert(tgtObject ~= nil, 'tgtObject being registered is nil')

	tgtObject.uid = self.historicCounter + 1
	self.historicCounter = self.historicCounter + 1

	if self.registry[tgtObject.uid] ~= nil then
		print('Registry object with uid already exists ' .. tgtObject.uid) --TODO; fails for now if we have a uid collision. Perhaps do a smart-update in the future
	else
		self.registry[tgtObject.uid] = tgtObject
	end

	return tgtObject.uid
end

function Registry:get ( tgtObjectId )
	return self.registry[tgtObjectId]
end

function Registry:summarize ( )
	print("Registry has " .. #self.registry .. " entries ")
end

function Registry:getCount ()
	return #self.registry
end

return Registry