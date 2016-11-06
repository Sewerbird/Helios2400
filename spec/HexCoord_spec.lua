inspect = require 'lib/inspect'
HexCoord = require 'src/HexCoord' 

describe('HexCoord', function ()
	it('should initialize correctly', function ()
		local my_HexCoord = HexCoord:new(2,3)
		assert.truthy(my_HexCoord)
		assert.are.same(my_HexCoord:toString(),"2_3")
	end)
end)
