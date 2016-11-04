inspect = require 'lib/inspect'
Interfaceable = require 'src/Interfaceable' 

describe('Interfaceable', function ()
	it('should initialize correctly', function ()
		assert.has_error(function() Interfaceable:new() end, 'Tried to create Interfaceable without a delegate')
	end)
end)
