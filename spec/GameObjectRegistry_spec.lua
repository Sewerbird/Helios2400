inspect = require 'lib/inspect'
GameObjectRegistry = require 'src/GameObjectRegistry' 
GameObject = require 'src/GameObject'

describe('GameObjectRegistry', function ()
	it('should initialize correctly', function ()
		local my_GameObjectRegistry = GameObjectRegistry:new()
		assert.truthy(my_GameObjectRegistry)
	end)

	it('should add objects but then deal in ids', function ()
		local myr = GameObjectRegistry:new()
		local moo = GameObject:new()
		local result = myr:add(moo)

		assert.are.equal(myr:get(result),moo)
	end)
end)
