inspect = require 'lib/inspect'
Transform = require 'src/component/Transform' 

describe('Transform', function ()
	it('should initialize correctly', function ()
		local my_Transform = Transform:new()
		assert.truthy(my_Transform)
	end)

	it('should translate/untranslate correctly', function ()
		local my_Transform = Transform:new()

		my_Transform:translate(3,4)
		my_Transform:untranslate(4,3)

		assert.are.same(my_Transform.x,-1)
		assert.are.same(my_Transform.y,1)
	end)
end)
