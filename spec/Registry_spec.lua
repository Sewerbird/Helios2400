inspect = require 'lib/inspect'
Registry = require 'src/Registry' 
GameObject = require 'src/GameObject'

describe('Registry', function ()
	it('should initialize correctly', function ()
		local my_Registry = Registry:new()
		assert.truthy(my_Registry)
	end)

	it('should add objects but then deal in ids', function ()
		local myr = Registry:new()
		local moo = GameObject:new()
		local result = myr:add(moo)

		assert.are.equal(myr:get(result),moo)
	end)
end)
