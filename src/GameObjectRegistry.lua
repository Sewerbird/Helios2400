--GameObjectRegistry.lua
local GameObjectRegistry = class('GameObjectRegistry', {
	registry = {},
	historicCounter = 1
})

function GameObjectRegistry:init ( )
end

function GameObjectRegistry:add ( gameObject )
	assert(gameObject ~= nil, 'Gameobject being registered is nil')

	gameObject.uid = self.historicCounter + 1
	self.historicCounter = self.historicCounter + 1

	if self.registry[gameObject.uid] ~= nil then
		print('Gameobject with uid already exists ' .. gameObject.uid) --TODO; fails for now if we have a uid collision. Perhaps do a smart-update in the future
	else
		self.registry[gameObject.uid] = gameObject
	end

	return gameObject.uid
end

function GameObjectRegistry:get ( gameObjectId )
	return self.registry[gameObjectId]
end

return GameObjectRegistry