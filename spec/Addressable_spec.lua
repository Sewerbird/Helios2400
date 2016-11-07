inspect = require 'lib/inspect'
Addressable = require 'src/component/Addressable' 

describe('Addressable', function ()
	it('should initialize correctly', function ()
		local my_Addressable = Addressable:new('101',{})
		assert.truthy(my_Addressable)
	end)

	it('should not allow itself in its list of neighbors', function ()
		local me = Addressable:new('101',{})
		assert.has_error(function () 
			local me = Addressable:new('101', {'101'})
		end, 'Tried to create addressable as its own neighbor')
	end)
end)
