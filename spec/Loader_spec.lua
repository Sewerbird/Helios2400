inspect = require 'lib/inspect'
Loader = require 'src/Loader' 

describe('Loader', function ()
	it('should initialize correctly', function ()
		local my_Loader = Loader:new()
		assert.truthy(my_Loader)
	end)
end)
