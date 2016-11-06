inspect = require 'lib/inspect'
System = require 'src/System' 

describe('System', function ()
	it('should initialize correctly', function ()
		local my_System = System:new()
		assert.truthy(my_System)
	end)
end)
