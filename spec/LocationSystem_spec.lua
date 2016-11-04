inspect = require 'lib/inspect'
LocationSystem = require 'src/LocationSystem' 

describe('LocationSystem', function ()
	it('should initialize correctly', function ()
		local my_LocationSystem = LocationSystem:new()
		assert.truthy(my_LocationSystem)
	end)
end)
