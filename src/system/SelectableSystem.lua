--SelectableSystem.lua
local System = require 'src/System'
local GameObject = require 'src/GameObject'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
local Placeable = require 'src/component/Placeable'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local MoveArmyMutator = require 'src/state/mutator/MoveArmyMutator'

local SelectableSystem = System:extend({
	current_selection = nil,
	selected_unit_cursor_object = nil
})

function SelectableSystem:init (registry, targetCollection, cursor_sprite)
	SelectableSystem.super.init(self, registry, targetCollection)
	self.selected_unit_cursor_object = self.registry:add(GameObject:new('Cursor',{
		Transform:new(0,0),
	    Renderable:new(
	      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
	      Global.Assets:getAsset(cursor_sprite)
	      ),
	    Placeable:new()
	}))

	local unsubSelect= Global.PubSub:subscribe("select", function (this, msg)
		self:select(msg.uid)
	end)

	local unsubMoveTo = Global.PubSub:subscribe("moveTo", function (this, msg)
		self:moveSelectedTo(msg.uid, msg.address)
	end)
end

function SelectableSystem:select ( gameObjectId )
	if self.current_selection ~= nil then 
		local tgtObj = self.registry:get(self.current_selection)
		local cursor = self.registry:get(self.selected_unit_cursor_object)
		self.targetCollection:detach(self.selected_unit_cursor_object, self.current_selection)
		--tgtObj:getComponent('Selectable'):deselect()

	end
	if self.current_selection == gameObjectId then 
		self.current_selection = nil
		return
	end
	self.current_selection = gameObjectId
	if self.current_selection ~= nil then
		self:resetCursor()
		local tgtObj = self.registry:get(self.current_selection)
		self.targetCollection:attach(self.selected_unit_cursor_object, self.current_selection)
		self:centerCursor(tgtObj)
		--tgtObj:getComponent('Selectable'):select()
	end
end

function SelectableSystem:resetCursor ()
	self.registry:get(self.selected_unit_cursor_object):getComponent('Transform'):teleport(0,0)
end

function SelectableSystem:centerCursor ( gameObject )
	local tgtRenderable = gameObject:getComponent('Renderable')
	if tgtRenderable ~= nil then
		local cursor = self.registry:get(self.selected_unit_cursor_object)
		local cursorpoly = cursor:getComponent('Renderable').polygon
		cursor:getComponent('Transform'):translate( tgtRenderable.polygon.w/2 - cursorpoly.w/2 ,  tgtRenderable.polygon.h/2 - cursorpoly.h/2)
	end
end

function SelectableSystem:moveSelectedTo (tgtGameObjectId, tgtAddress)
	if self.current_selection ~= nil and self.current_selection ~= tgtGameObjectId then --something might be moveable
		local srcObj = self.registry:get(self.current_selection)
		local dstObj = self.registry:get(tgtGameObjectId)

		if srcObj:hasComponent('Moveable') and srcObj:hasComponent('Placeable') and dstObj:hasComponent('Addressable') then
			--TODO: make this generate a mutator instead
			local mutMove = MoveArmyMutator:new(
				srcObj:getComponent('Stateful').ref, 
				srcObj:getComponent('Stateful').ref,
				dstObj:getComponent('Stateful').ref,
				srcObj:getComponent('Placeable').address, 
				dstObj:getComponent('Addressable').address, 
				0)
			Global.PubSub:publish("IMMEDIATE_MUTATE", mutMove)
		else
			self:select(tgtGameObjectId)
		end
	else
		self:select(tgtGameObjectId)
	end
end

return SelectableSystem