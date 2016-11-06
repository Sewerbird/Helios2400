inspect = require 'lib/inspect'
Component = require 'src/Component' 
GameObject = require 'src/GameObject'

describe('Component', function ()
	it('should initialize correctly', function ()
		local my_Component = Component:new()
		assert.truthy(my_Component)
	end)

	it('should set its metadata when onAdd is called', function ()
		local my_component = Component:new()
		local my_gob = {uid = 'foo'}
		my_component:onAdd(my_gob)

		assert.are.equal(my_component:getObject(),my_gob)
		assert.are.same(my_component.gid,my_gob.uid)
	end)

	it('should be able find sibling component', function()
		local my_component = Component:new()
		my_component.name="me"
		local my_sister = Component:new()
		my_sister.name="sister"
		local my_gob = GameObject:new("Test_Object",{my_component, my_sister})

		assert.are.equal(my_component:getSiblingComponent('sister'),my_sister)
	end)

end)
