--MoveArmyMutator_spec.lua
local MoveArmyMutator = require 'src/state/mutator/MoveArmyMutator'
local GameInfo = require 'src/component/GameInfo'
local GameObject = require 'src/GameObject'
local Registry = require 'src/structure/Registry'
local PubSub = require 'src/PubSub'
describe('MoveArmyMutator', function()

	it('Is able to apply and rollback', function ()
		local testObject = GameObject:new("testobj",{
			GameInfo:new({
				curr_move = 10,
				address = "sad_place"
			})
		})
		local testPubSub = PubSub:new()
		local testRegistry = Registry:new()
		local testObjectRef = testRegistry:add(testObject)

		assert.are.equal(testObject, testRegistry:get(testObjectRef))

		local mut = MoveArmyMutator:new(
			testObjectRef,
			"meow",
			"meow",
			"sad_place",
			"happy_place",
			5)
		mut:apply(testRegistry,testPubSub)

		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').address, "happy_place")
		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').curr_move, 5)

		mut:rollback(testRegistry,testPubSub)

		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').address, "sad_place")
		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').curr_move, 10)

	end)
end)
