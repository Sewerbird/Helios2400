inspect = require 'lib/inspect'
AddressableSystem = require 'src/AddressableSystem' 
GameObjectRegistry = require 'src/GameObjectRegistry'

describe('AddressableSystem', function ()
	it('should initialize correctly', function ()
		local registry = GameObjectRegistry:new()
		local my_AddressableSystem = AddressableSystem:new(registry)
		assert.truthy(my_AddressableSystem)
	end)
end)
