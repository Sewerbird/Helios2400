inspect = require 'lib/inspect'
Addressable = require 'src/component/Addressable' 

describe('Addressable', function ()
	it('should initialize correctly', function ()
		local my_Addressable = Addressable:new('101',{})
		assert.truthy(my_Addressable)
		assert.are.equal(my_Addressable.address,'101')
	end)
end)
