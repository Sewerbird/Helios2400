inspect = require 'lib/inspect'
Addressable = require 'src/Addressable' 

describe('Addressable', function ()
	it('should initialize correctly', function ()
		local my_Addressable = Addressable:new()
		assert.truthy(my_Addressable)
	end)
end)
