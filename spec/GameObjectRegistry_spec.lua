inspect = require 'lib/inspect'
GameObjectRegistry = require 'src/GameObjectRegistry' 

describe('GameObjectRegistry', function ()
	it('should initialize correctly', function ()
		local my_GameObjectRegistry = GameObjectRegistry:new()
		assert.truthy(my_GameObjectRegistry)
	end)
end)
