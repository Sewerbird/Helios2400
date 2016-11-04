inspect = require 'lib/inspect'
SelectableSystem = require 'src/SelectableSystem' 

describe('SelectableSystem', function ()
	it('should initialize correctly', function ()
		local my_SelectableSystem = SelectableSystem:new()
		assert.truthy(my_SelectableSystem)
	end)
end)
