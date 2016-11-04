inspect = require 'lib/inspect'
Component = require 'src/Component' 

describe('Component', function ()
	it('should initialize correctly', function ()
		local my_Component = Component:new()
		assert.truthy(my_Component)
	end)
end)
