inspect = require 'lib/inspect'
GameObject = require 'src/GameObject' 
Component = require 'src/Component'

describe('GameObject', function ()
	it('should initialize correctly', function ()
		local my_GameObject = GameObject:new()
		assert.truthy(my_GameObject)
	end)

	it('should successfully keep track of its components', function() 
		local gob = GameObject:new()
		gob.uid = "123456"
		local c1 = Component:new()
		local c2 = Component:new()
		local c3 = Component:new()
		c1.name = 'foo1'
		c2.name = 'foo2'
		c3.name = 'foo3'

		gob:addComponent(c1)
		gob:addComponent(c2)
		gob:addComponent(c3)

		assert.are.equal(gob:getComponent('foo1'),c1)
		assert.are.equal(gob:getComponent('foo2'),c2)
		assert.are.equal(gob:getComponent('foo3'),c3)
	end)
end)
