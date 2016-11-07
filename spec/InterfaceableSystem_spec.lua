inspect = require 'lib/inspect'
InterfaceableSystem = require 'src/system/InterfaceableSystem' 
Registry = require 'src/structure/Registry'

describe('InterfaceableSystem', function ()
	it('should initialize correctly', function ()
		local registry = Registry:new()
		local my_InterfaceableSystem = InterfaceableSystem:new(registry)
		assert.truthy(my_InterfaceableSystem)
	end)
end)
