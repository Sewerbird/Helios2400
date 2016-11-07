inspect = require 'lib/inspect'
RenderableSystem = require 'src/system/RenderableSystem' 
Registry = require 'src/structure/Registry'

describe('RenderableSystem', function ()
	it('should initialize correctly', function ()
		local registry = Registry:new()
		local my_RenderableSystem = RenderableSystem:new(registry)
		assert.truthy(my_RenderableSystem)
	end)
end)
