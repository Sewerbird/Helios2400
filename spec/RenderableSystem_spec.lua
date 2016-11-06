inspect = require 'lib/inspect'
RenderableSystem = require 'src/RenderableSystem' 
GameObjectRegistry = require 'src/GameObjectRegistry'

describe('RenderableSystem', function ()
	it('should initialize correctly', function ()
		local registry = GameObjectRegistry:new()
		local my_RenderableSystem = RenderableSystem:new(registry)
		assert.truthy(my_RenderableSystem)
	end)
end)
