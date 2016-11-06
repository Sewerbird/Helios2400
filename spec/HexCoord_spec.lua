inspect = require 'lib/inspect'
HexCoord = require 'src/HexCoord' 

describe('HexCoord', function ()
	it('should initialize correctly', function ()
		local my_HexCoord = HexCoord:new()
		assert.truthy(my_HexCoord)
	end)
end)
