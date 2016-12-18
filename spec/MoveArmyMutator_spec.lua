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
		local testDestination = testRegistry:add(GameObject:new("testobj",{
			GameInfo:new({
				gs_type = "tile",
				address = "sad_place"
				})
			}))
		local testOrigin = testRegistry:add(GameObject:new("testobj",{
			GameInfo:new({
				gs_type = "tile",
				address = "happy_place"
				})
			}))

		assert.are.equal(testObject, testRegistry:get(testObjectRef))

		local mut = MoveArmyMutator:new(
			testObjectRef,
			"happy_place",
			"sad_place",
			5)

      	spy.on(testRegistry.pubsub, "publish")

		mut:apply(testRegistry)

		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').address, "sad_place")
		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').curr_move, 5)

		testRegistry.pubsub.publish:clear()
		mut:rollback(testRegistry)

		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').address, "happy_place")
		assert.are.same(testRegistry:get(testObjectRef):getComponent('GameInfo').curr_move, 10)

	end)
end)
