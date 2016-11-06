inspect = require 'lib/inspect'
AddressableSystem = require 'src/AddressableSystem' 

describe('AddressableSystem', function ()
	it('should initialize correctly', function ()
		local my_AddressableSystem = AddressableSystem:new()
		assert.truthy(my_AddressableSystem)
	end)
end)
