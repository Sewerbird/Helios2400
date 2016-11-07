inspect = require 'lib/inspect'
SelectableSystem = require 'src/system/SelectableSystem' 
Registry = require 'src/structure/Registry'

describe('SelectableSystem', function ()
	it('should initialize correctly', function ()
		local registry = Registry:new()
		local my_SelectableSystem = SelectableSystem:new(registry)
		assert.truthy(my_SelectableSystem)
	end)
end)
