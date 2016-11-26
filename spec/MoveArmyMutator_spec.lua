--MoveArmyMutator_spec.lua
local MoveArmyMutator = require 'src/mutate/mutator/MoveArmyMutator'
local GameInfo = require 'src/component/GameInfo'
local GameObject = require 'src/GameObject'
local Registry = require 'src/Registry'
local PubSub = require 'src/PubSub'
local inspect = require 'lib/inspect'


local function has_values (state, expected_values)
	local expected = expected_values[1]
	return function(value)
		for key, val in pairs(expected) do
			if value[key] ~= val then 
				print('Failed key is ' .. key .. ': was ' .. tostring(value[key]) .. ', but expecting ' .. tostring(val))
				return false 
			end
		end
		return true
	end
end

local function debug_any (state, expected_values)
	print('registered')
	return function(value)
		print('called')
		print('accepting any, go ' .. inspect(value))
		return true
	end
end

assert:register("matcher","has_values", has_values)
assert:register("matcher","debug_any", debug_any)

describe('MoveArmyMutator', function()

	it('Is able to apply and rollback', function ()
		local testObject = GameObject:new("testobj",{
			GameInfo:new({
				curr_move = 10,
				address = "happy_place"
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
			"happy_place",
			"sad_place",
			5)

      	spy.on(testPubSub, "publish")

		mut:apply(testRegistry,testPubSub)

		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').address, "sad_place")
		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').curr_move, 5)
		assert.spy(testPubSub.publish).was.called_with(match._, testObjectRef, match.has_values(
			{
				subject = "moved",
				origin_info = "meow",
				destination_info = "meow",
				origin_address = "happy_place",
				destination_address = "sad_place",
				move_cost = 5
			}))

		testPubSub.publish:clear()
		mut:rollback(testRegistry,testPubSub)

		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').address, "happy_place")
		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').curr_move, 10)
		assert.spy(testPubSub.publish).was.called_with(match._, testObjectRef, match.has_values(
			{
				subject = "moved",
				origin_info = "meow",
				destination_info = "meow",
				origin_address = "sad_place",
				destination_address = "happy_place",
				move_cost = 5
			}))
	end)
end)
