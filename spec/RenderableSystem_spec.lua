inspect = require 'lib/inspect'
RenderableSystem = require 'src/RenderableSystem' 

describe('RenderableSystem', function ()
	it('should initialize correctly', function ()
		local my_RenderableSystem = RenderableSystem:new()
		assert.truthy(my_RenderableSystem)
	end)
end)
