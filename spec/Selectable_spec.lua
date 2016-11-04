inspect = require 'lib/inspect'
Selectable = require 'src/Selectable' 

describe('Selectable', function ()
	it('should initialize correctly', function ()
		local my_Selectable = Selectable:new()
		assert.truthy(my_Selectable)
	end)
end)
