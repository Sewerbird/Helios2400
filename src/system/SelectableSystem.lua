--SelectableSystem.lua
local System = require 'src/System'
local GameObject = require 'src/GameObject'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
local Placeable = require 'src/component/Placeable'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local MoveArmyMutator = require 'src/mutate/mutator/MoveArmyMutator'

local SelectableSystem = System:extend({
	current_selection = nil,
	selected_unit_cursor_object = nil,
	path = nil,
	path_overlays = {}
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
	self.path_overlays = {}

	local unsubSelect= self.registry:subscribe("select", function (this, msg)
		if self.targetCollection:has(msg.uid) then
			self:select(msg.uid)
		end
	end)

	local unsubPathTo = self.registry:subscribe("pathTo", function (this, msg)
		self:pathTo(msg.uid, msg.address, msg.map)
		self:displayPathOverlay(msg.map)
	end)
	
	local unsubMoveTo = self.registry:subscribe("moveTo", function (this, msg)
		if self.targetCollection:has(msg.uid) then
			self:moveSelectedTo(msg.uid, msg.address)
		end
	end)
end

function SelectableSystem:select ( gameObjectId )
	if self.current_selection ~= nil then 
		local tgtObj = self.registry:get(self.current_selection)
		local cursor = self.registry:get(self.selected_unit_cursor_object)
		self.targetCollection:detach(self.selected_unit_cursor_object, self.current_selection)
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
	end
end

function SelectableSystem:resetCursor ()
	self.registry:get(self.selected_unit_cursor_object):getComponent('Transform'):teleport(0,0)
	self:clearPathOverlay()
end

function SelectableSystem:centerCursor ( gameObject )
	local tgtRenderable = gameObject:getComponent('Renderable')
	if tgtRenderable ~= nil then
		local cursor = self.registry:get(self.selected_unit_cursor_object)
		local cursorpoly = cursor:getComponent('Renderable').polygon
		cursor:getComponent('Transform'):translate( tgtRenderable.polygon.w/2 - cursorpoly.w/2 ,  tgtRenderable.polygon.h/2 - cursorpoly.h/2)
	end
end

function SelectableSystem:displayPathOverlay (map)
	if not self.path then return end
	self:clearPathOverlay()


	local tilesOnWay = self.registry:getIdsByPool("Addressable", function(obj)
		local transform = obj:getComponent("Transform")
		local renObj = obj:getComponent("Renderable")
		local addObj = obj:getComponent("Addressable")

		for i, step in ipairs(self.path) do
			if renObj and addObj.address == step then
				return true
			end
		end
	end)
	for i, tileOnWay in ipairs(tilesOnWay) do
		local s = self.registry:get(tileOnWay)
		if s then
			local overlay = self.registry:add(GameObject:new('Cursor',{
				Transform:new(s.x,s.y),
			    Renderable:new(
			      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			      Global.Assets:getAsset("CURSOR_1")
			      ),
			    Placeable:new()
			}))
			table.insert(self.path_overlays, overlay)
			self.targetCollection:attach(overlay,tileOnWay)
		end
	end
end

function SelectableSystem:clearPathOverlay ()
	if self.path_overlays then
		for i, overlay in ipairs(self.path_overlays) do
			self.targetCollection:detach(overlay)
			self.registry:remove(overlay)
		end
		self.path_overlays = {}
	end
end

function SelectableSystem:pathTo(fromId, tgtAddress, map)
	if self.current_selection ~= nil then
		local curObj = self.registry:get(self.current_selection)
		local fromAddress = curObj:getComponent('Placeable').address
		local toAddress = tgtAddress.address
		self.path = map:findPath(fromAddress, toAddress)
		print("Path: " .. inspect(self.path))
	end
	-- body
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
			self.registry:publish("IMMEDIATE_MUTATE", mutMove)
		else
			self:select(tgtGameObjectId)
		end
	else
		self:select(tgtGameObjectId)
	end
end

return SelectableSystem