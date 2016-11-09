inspect = require 'lib/inspect'
IndexMap = require 'src/structure/IndexMap' 

describe('IndexMap', function ()
	it('should initialize correctly', function ()
		local myMap = IndexMap:new()
		assert.truthy(myMap)
	end)

	it('should load and link addresses correctly', function ()
		local mym = IndexMap:new()

		mym:addAddress('a',{'1','2','3','4','5','6'})
		mym:addAddress('1',{'a','2','6'})
		mym:addAddress('2',{'a','1','3'})
		mym:addAddress('3',{'a','2','4'},{'objA'})
		mym:addAddress('4',{'a','3','5'},{'objB'})
		mym:addAddress('5',{'a','4','6'})
		mym:addAddress('6',{'a','5','1'})

		local placed

		placed = mym:getPlaceablesAt('3')
		assert.are.same(#placed,1)

		placed = mym:getPlaceablesAt('2')
		assert.are.same(#placed,0)

		assert.are.same(mym:findPlaceableAddress('objA'),'3')
		assert.are.same(mym:hasPlaceable('3','objA'), true)
		assert.are.same(mym:hasPlaceable('2','objA'), false)

		mym:movePlaceable('objA','3','4')

		placed = mym:getPlaceablesAt('4')
		assert.are.same(#placed,2)

		placed = mym:getPlaceablesAt('3')
		assert.are.same(#placed,0)

		assert.are.same(mym:getNeighbors('a'),{'1','2','3','4','5','6'})
		assert.are.same(mym:getNeighbors('3'),{'a','2','4'})
	end)
end)
