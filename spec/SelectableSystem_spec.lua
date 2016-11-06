inspect = require 'lib/inspect'
SelectableSystem = require 'src/SelectableSystem' 
GameObjectRegistry = require 'src/GameObjectRegistry'

describe('SelectableSystem', function ()
	it('should initialize correctly', function ()
		local registry = GameObjectRegistry:new()
		local my_SelectableSystem = SelectableSystem:new(registry)
		assert.truthy(my_SelectableSystem)
	end)
end)
