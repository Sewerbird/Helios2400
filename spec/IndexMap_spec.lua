inspect = require 'lib/inspect'
IndexMap = require 'src/structure/IndexMap' 
Location = 

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
		mym:addAddress('3',{'a','2','4'},nil,{'objA'})
		mym:addAddress('4',{'a','3','5'},nil,{'objB'})
		mym:addAddress('5',{'a','4','6'})
		mym:addAddress('6',{'a','5','1'})

		local placed

		placed = mym:getPlaceablesAt('3')
		assert.are.same(placed,{'objA'})
		assert.are.same(#placed,1)

		placed = mym:getPlaceablesAt('2')
		assert.are.same(placed,{})
		assert.are.same(#placed,0)

		assert.are.same(mym:findPlaceableAddress('objA'),'3')
		assert.are.same(mym:hasPlaceable('3','objA'), true)
		assert.are.same(mym:hasPlaceable('2','objA'), false)

		mym:movePlaceable('objA','3','4')

		placed = mym:getPlaceablesAt('4')
		assert.are.same(#placed,2)
		assert.are.same(placed,{'objB','objA'})

		placed = mym:getPlaceablesAt('3')
		assert.are.same(#placed,0)
		assert.are.same(placed,{})

		assert.are.same(mym:getNeighbors('a'),{'1','2','3','4','5','6'})
		assert.are.same(mym:getNeighbors('3'),{'a','2','4'})
	end)
end)

describe('IndexMap pathfinding', function ()

	function buildGrid()
		local myMap = IndexMap:new()
		local width = 9
		for i=1,width do
			for j=1,width do
				local neighborAddresses = {}
				if i - 1 >= 1 then table.insert(neighborAddresses, "AD" .. i - 1 .. j) end
				if j - 1 >= 1 then table.insert(neighborAddresses, "AD" .. i .. j - 1) end
				if i + 1 <= width then table.insert(neighborAddresses, "AD" .. i + 1 .. j) end
				if j + 1 <= width then table.insert(neighborAddresses, "AD" .. i  .. j + 1) end
				if j % 2 == 0 then 
					if i - 1 >= 1 and j + 1 <= width then table.insert(neighborAddresses, "AD" .. i - 1  .. j + 1) end
					if i + 1 <= width and j + 1 <= width then table.insert(neighborAddresses, "AD" .. i + 1  .. j + 1) end
				end
				local terrain_info = {
          			land = math.random(7),
					sea = math.random(8),
					aero = math.random(4),
					hover = math.random(6),
					space = math.random(3),
					reentry = math.random(10),
					toxic = false,--math.random() > 0.8,
					vacuum = false,--math.random() > 0.8,
					shielded = false,--math.random() > 0.8,
			        }
				myMap:addAddress("AD" .. i .. j, neighborAddresses, terrain_info, {})
			end
		end
		return myMap
	end

	it('should initialize correctly with 9x9 grid of hexagonal connected addresses without error', function ()
		buildGrid();
	end)

	it('should find a path across the whole map', function ()
		local myMap = buildGrid();
		local path, cost = myMap:findPath("AD11","AD99")
		assert.truthy(path)
		assert.are_not.equal(path,{})
	end)

	it('should be able to use all movement types', function ()
		local myMap = buildGrid();
		local path, cost = myMap:findPath("AD11","AD99")
		assert.truthy(path)
		assert.are_not.equal(path,{})
		path, cost = myMap:findPath("AD11","AD99","land")
		assert.truthy(path)
		assert.are_not.equal(path,{})
		path, cost = myMap:findPath("AD11","AD99","sea")
		assert.truthy(path)
		assert.are_not.equal(path,{})
		path, cost = myMap:findPath("AD11","AD99","aero")
		assert.truthy(path)
		assert.are_not.equal(path,{})
		path, cost = myMap:findPath("AD11","AD99","hover")
		assert.truthy(path)
		assert.are_not.equal(path,{})
		path, cost = myMap:findPath("AD11","AD99","space")
		assert.truthy(path)
		assert.are_not.equal(path,{})
		path, cost = myMap:findPath("AD11","AD99","reentry")
		assert.truthy(path)
		assert.are_not.equal(path,{})
	end)

	it('should return a nil if goal or starting point doesn\'t exist', function()
		local myMap = buildGrid();
		path, cost = myMap:findPath("ADxx","AD34","space")
		assert.falsy(path)
		path, cost = myMap:findPath("AD34","ADuu","space")
		assert.falsy(path)
		path, cost = myMap:findPath("ADpp","ADrr","space")
		assert.falsy(path)
	end)

end)
