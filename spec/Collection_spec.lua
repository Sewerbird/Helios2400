inspect = require 'lib/inspect'
Collection = require 'src/Collection' 

describe('Collection', function ()
	it('should initialize correctly', function ()
		local my_Collection = Collection:new()
		assert.truthy(my_Collection)
	end)
end)
