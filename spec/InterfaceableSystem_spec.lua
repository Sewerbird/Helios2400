inspect = require 'lib/inspect'
InterfaceableSystem = require 'src/InterfaceableSystem' 
GameObjectRegistry = require 'src/GameObjectRegistry'

describe('InterfaceableSystem', function ()
	it('should initialize correctly', function ()
		local registry = GameObjectRegistry:new()
		local my_InterfaceableSystem = InterfaceableSystem:new(registry)
		assert.truthy(my_InterfaceableSystem)
	end)
end)
