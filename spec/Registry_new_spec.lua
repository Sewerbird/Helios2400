inspect = require 'lib/inspect'
Registry, Component, Binding = require('src/Registry_new')()

function Component:foo (val)
	return "FOO!"
end

function makeSingletonObject(registry,type)
	return registry:make(
			'Simple object', {
				Component:new(type, {
					num = 1, 
					str = "2",
					bool = true
				})
			})
end

describe('Registry', function ()
--[[
	it('should initialize correctly', function ()
		local my_Registry = Registry:new()
		assert.truthy(my_Registry)
	end)

	it('should allow creation & retrieval of a object with one primitive component', function ()
		local my_reg = Registry:new()
		local my_gid = makeSingletonObject(my_reg,'Primitive')

		assert.are.equal(my_gid, 1)

		local primitive = my_reg:get(my_gid, "Primitive")

		assert.are.equal(primitive.num, 1)
		assert.are.equal(primitive.str, "2")
		assert.are.equal(primitive.bool, true)
	end)

	it('should allow retrieval of a primitive datum direct from an object reference', function()
		local my_reg = Registry:new()
		local my_gid = makeSingletonObject(my_reg,'Primitive')

		assert.are.equal(my_reg:get(my_gid, "Primitive.num"), 1)
		assert.are.equal(my_reg:get(my_gid, "Primitive.str"), "2")
		assert.are.equal(my_reg:get(my_gid, "Primitive.bool"), true)
	end)

	it('should allow changing the value of a primitive datum from a component', function()
		local my_reg = Registry:new()
		local my_gid = makeSingletonObject(my_reg,'Primitive')

		--Component->Datum writes work transparently
		local primitive = my_reg:get(my_gid, "Primitive")

		primitive.num = 3
		assert.are.equal(primitive.num, 3)

		--Component->Datum writes propogate to other component references
		local primitive_prime = my_reg:get(my_gid, "Primitive")

		primitive_prime.num = primitive_prime.num + 3
		assert.are.equal(primitive.num, 6)

		--Datum writes act simply and do not propogate
		local primitive_prime_num = my_reg:get(my_gid, "Primitive.num")

		primitive_prime_num = primitive_prime_num + 3
		assert.are.equal(primitive_prime.num, 6)
	end)

	it('should return only the kinds of components I ask for in find/findAll', function()
		local my_reg = Registry:new()
		local p1 = makeSingletonObject(my_reg,'Primitive')
		local p2 = makeSingletonObject(my_reg,'Primitive')
		local p3 = makeSingletonObject(my_reg,'Primitive')
		local m1 = makeSingletonObject(my_reg,'Modern')
		local a1 = makeSingletonObject(my_reg,'Clarkian')

		local primitives = my_reg:findAll('Primitive')
		local moderns = my_reg:findAll('Modern')
		local advanceds = my_reg:findAll('Clarkian')
		local whereTrue = my_reg:findAll('Primitive',{bool = true})

		assert.are.equal(#primitives, 3)
		assert.are.equal(#moderns, 1)
		assert.are.equal(#advanceds, 1)

		primitives[2].num = 5
		local whereFivePrimitive = my_reg:find('Primitive',{num = 5})
		local whereFiveModern = my_reg:find('Modern', {num = 5})

		assert.are.equal(whereFiveModern, nil)
		assert.are.equal(whereFivePrimitive.num, 5)
	end)

	it('should follow bindings to their targets when doing a get', function()
		local my_reg = Registry:new()
		local p1 = makeSingletonObject(my_reg,'Primitive')
		local p2 = my_reg:make('Dependent object', {
			Component:new('Renderable', {
				my_primitive = 'foo',
				my_reference = Binding:new(p1, 'Primitive.num')
			}),	
			Component:new('Renderable', {
				my_primitive = 'foo',
				my_reference = Binding:new(p1, 'Primitive.num')
			})	
		})	

		local deep_resultA = my_reg:get(p2, 'Renderable.my_reference')
		local deep_resultB = my_reg:get(p2, 'Renderable.my_reference.num')

		assert.are.equal(deep_resultA, 1)
		assert.are.equal(deep_resultB, 1)
	end)

	it('can go through multiple binding redirects', function()
		local my_reg = Registry:new()
		local pallete = my_reg:make('PalleteThing', {
			Component:new('PalleteInfo', {
				background_color = 'red',
				shadow_color = {255,0,0},
				forecolor = 'pink',
				bright_color = {255,255,255}
			})
		})
		local player = my_reg:make('PlayerThing', {
			Component:new('PlayerInfo', {
				pallete = Binding:new(pallete, 'PalleteInfo'),
				palletecolor = Binding:new(pallete, 'PalleteInfo.shadow_color')
			})
		})
		local unit = my_reg:make('UnitThing',{
			Component:new('UnitInfo', {
				owner = Binding:new(player, 'PlayerInfo'),
				ownerpallete = Binding:new(player, 'PlayerInfo.pallete'),
				mycolor = Binding:new(player, 'PlayerInfo.pallete.shadow_color')
			})
		})

		local unitcolorA = my_reg:get(unit, 'UnitInfo.owner.pallete.shadow_color')
		local unitcolorB = my_reg:get(unit, 'UnitInfo.owner.palletecolor')
		local unitcolorC = my_reg:get(unit, 'UnitInfo.ownerpallete.shadow_color')
		local unitcolorD = my_reg:get(unit, 'UnitInfo.mycolor')

		assert.are.same(unitcolorA, {255, 0, 0})
		assert.are.equal(unitcolorA, unitcolorB)
		assert.are.equal(unitcolorB, unitcolorC)
		assert.are.equal(unitcolorC, unitcolorD)
		assert.are.equal(unitcolorD, unitcolorA)
	end)

	it('can use a component in calling code', function()
		local my_reg = Registry:new()
		local foo_thing = my_reg:make('FooThing', {
			Component:new('Foo', {
				fun_val = 'zambam'
			})
		})

		local fun = my_reg:get(foo_thing, 'Foo')
		assert.are.same(fun.fun_val,"zambam")
		assert.are.same(fun:foo(),"FOO!")
	end)
--]]
	it('respects the presence of a functor in a binding', function()
		local my_reg = Registry:new()
		local referenced_obj = my_reg:make('TargetThing',{
			Component:new('TargetComponent', {
				basic_val = 'Foo'
			})
		})
		local test_obj = my_reg:make('TestThing',{
			Component:new('TestComponent',{
				derived_val = Binding:new(referenced_obj, 'TargetComponent.basic_val', function(val) 
					return val .. "is correctly modified" 
				end)
			})
		})

		local verify = my_reg:get(test_obj, "TestComponent.derived_val")

		assert.are.same(verify,"Foo is correctly modified")
	end)

end)
