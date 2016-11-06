inspect = require 'lib/inspect'
Polygon = require 'src/Polygon' 

describe('Polygon', function ()
	it('should initialize correctly', function ()
		assert.has_error(function() Polygon:new() end, 'Tried to create a polygon without vertices')
		assert.truthy(Polygon:new({0,0 , 1,0 , 1,1 , 0,1}))
	end)

	it('should correctly detect clicks within', function()

		local poly = Polygon:new({0,0 , 1,0, 1,1, 0,1})

		assert.is_true(poly:containsPoint(0.5,0.5))
		assert.is_true(poly:containsPoint(0.999, 0.999))
		assert.is_true(poly:containsPoint(0.001, 0.001))
		assert.is_false(poly:containsPoint(0,0))
		assert.is_false(poly:containsPoint(1,1))
		assert.is_false(poly:containsPoint(3,3))
		assert.is_false(poly:containsPoint(-1,-1))
	end)
end)
