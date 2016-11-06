inspect = require 'lib/inspect'
InterfaceableSystem = require 'src/InterfaceableSystem' 

describe('InterfaceableSystem', function ()
	it('should initialize correctly', function ()
		local my_InterfaceableSystem = InterfaceableSystem:new()
		assert.truthy(my_InterfaceableSystem)
	end)
end)
