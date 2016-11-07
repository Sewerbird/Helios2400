inspect = require 'lib/inspect'
Interfaceable = require 'src/component/Interfaceable' 
Transform = require 'src/component/Transform'
Polygon = require 'src/datatype/Polygon'
GameObject = require 'src/GameObject'
TouchDelegate = require 'src/datatype/TouchDelegate'

describe('Interfaceable', function ()
	it('should initialize correctly', function ()
		assert.has_error(function() Interfaceable:new() end, 'Tried to create Interfaceable without a delegate')
	end)

	it('should fire events when done within its polygon', function ()
		local myd = TouchDelegate:new()
		foo = "foo"
		myd:setHandler('onTouch',function(x,y)
			foo = 'bar'
		end)
		local myi = Interfaceable:new(Polygon:new({0,0 , 1,0, 1,1, 0,1}),myd)
		local gob = GameObject:new("test",{Transform:new(0,0)})
		gob:addComponent(myi)

		assert.is_true(myi:receivesTouch(0.5,0.5))
		myi:onTouch(-1,-1)
		assert.are.same(foo,"foo")
		myi:onTouch(0.5,0.5)
		assert.are.same(foo,"bar")
	end)
end)
