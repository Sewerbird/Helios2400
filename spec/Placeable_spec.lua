inspect = require 'lib/inspect'
Placeable = require 'src/component/Placeable' 

describe('Placeable', function ()
	it('should initialize correctly', function ()
		local my_Placeable = Placeable:new()
		assert.truthy(my_Placeable)
	end)
end)
