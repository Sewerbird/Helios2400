inspect = require 'lib/inspect'
TouchDelegate = require 'src/TouchDelegate' 

describe('TouchDelegate', function ()
	it('should initialize correctly', function ()
		local my_TouchDelegate = TouchDelegate:new()
		assert.truthy(my_TouchDelegate)
	end)
end)
