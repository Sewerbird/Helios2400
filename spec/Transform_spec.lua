inspect = require 'lib/inspect'
Transform = require 'src/Transform' 

describe('Transform', function ()
	it('should initialize correctly', function ()
		local my_Transform = Transform:new()
		assert.truthy(my_Transform)
	end)
end)
