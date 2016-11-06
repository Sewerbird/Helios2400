inspect = require 'lib/inspect'
PubSub = require 'src/PubSub' 

describe('PubSub', function ()
	it('should initialize correctly', function ()
		local my_PubSub = PubSub:new()
		assert.truthy(my_PubSub)
	end)
end)
