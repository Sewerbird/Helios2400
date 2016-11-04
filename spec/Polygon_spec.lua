inspect = require 'lib/inspect'
Polygon = require 'src/Polygon' 

describe('Polygon', function ()
	it('should initialize correctly', function ()
		assert.has_error(function() Polygon:new() end, 'Tried to create a polygon without vertices')
	end)
end)
