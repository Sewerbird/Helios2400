inspect = require 'lib/inspect'
Sprite = require 'src/Sprite' 

describe('Sprite', function ()
	it('should initialize correctly', function ()
		local my_Sprite = Sprite:new()
		assert.truthy(my_Sprite)
	end)
end)
