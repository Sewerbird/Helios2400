inspect = require 'lib/inspect'
Placeable = require 'src/component/Placeable' 

describe('Placeable', function ()
	it('should initialize correctly', function ()
		local my_Placeable = Placeable:new('101')
		assert.truthy(my_Placeable)
		assert.are.equal(my_Placeable.address,'101')
	end)
end)
