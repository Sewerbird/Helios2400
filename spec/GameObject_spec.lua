inspect = require 'lib/inspect'
GameObject = require 'src/GameObject' 

describe('GameObject', function ()
	it('should initialize correctly', function ()
		local my_GameObject = GameObject:new()
		assert.truthy(my_GameObject)
	end)
end)
