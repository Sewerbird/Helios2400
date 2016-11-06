inspect = require 'lib/inspect'
Renderable = require 'src/Renderable' 

describe('Renderable', function ()
	it('should initialize correctly', function ()
		local my_Renderable = Renderable:new()
		assert.truthy(my_Renderable)
	end)
end)
