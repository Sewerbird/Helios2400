inspect = require 'lib/inspect'
Collection = require 'src/Collection' 

describe('Collection', function ()
	local myc = Collection:new()

	before_each(function()
		--[[ 
		myc tree is...
			Z
			|-Za
			| `-A
			|   |-AA
			|   | `-AAA
			|   `.
			|     `.
			|       `_
			|-Zb    .  `AB
			|  `-B-'
			'-Zc
		]]
		myc = Collection:new()

		myc:attach('Z', nil)
		myc:attachAll({'Za','Zb','Zc'}, 'Z')
		myc:attach('A','Za')
		myc:attach('B','Zb')
		myc:attach('AA','A')
		myc:attach('AAA','AA')
		myc:attach('AB','A')
		myc:attach('AB','B')
	end)

	it('should build a tree correctly', function ()
		-- basic build tree validation
		assert.are.same(myc:getRoot(), 'Z')
		assert.are.same(myc:getParents('AB'),{'A','B'})
		assert.are.same(myc:getParent('AAA'),'AA')
		assert.are.same(myc:getParent('AA'),'A')
		assert.are.same(myc:getParent('A'),'Za')
		assert.are.same(myc:getParent('Za'),'Z')
		assert.are.same(myc:getParent('Z'),nil)
		assert.are.same(myc:getChildren('Z'),{'Za','Zb','Zc'})
		assert.are.same(myc:getChildren('Zc'),{})
	end)

	it('should handle detachment correctly', function ()
		myc:detach('Zc')
		assert.are.same(myc:getParent('Zc'),nil)
		assert.are.same(myc:getParents('Zc'),{})
		assert.are.same(myc:getChildren('Z'),{'Za','Zb'})

		myc:detach('AAA')
		assert.are.same(myc:hasChildren('AA'), false)
		assert.are.same(myc:getParent('AAA'), nil)

		myc:detach('A')
		assert.are.same(myc:hasChildren('Za'), false)
		assert.are.same(myc:getChildren('B'),{'AB'})
		assert.are.same(myc:getParents('AB'),{'A','B'})
	end)

end)
