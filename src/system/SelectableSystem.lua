--SelectableSystem.lua
local statemachine = require 'lib/statemachine'

local System = require 'src/System'
local GameObject = require 'src/GameObject'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
local Placeable = require 'src/component/Placeable'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local MoveArmyMutator = require 'src/mutate/mutator/MoveArmyMutator'
local CaptureCityMutator = require 'src/mutate/mutator/CaptureCityMutator'

local SelectableSystem = System:extend({
	current_selection = nil,
	selected_unit_cursor_object = nil,
	path = nil,
	path_cost = nil,
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

	self.fsm = statemachine.create({
		initial = 'idle',
		events = {
			{ name = 'clickedUnit', from = 'idle', to = 'unitSelected' },
			{ name = 'reclickedUnit', from = 'unitSelected', to = 'idle' },
			{ name = 'reclickedUnit', from = 'unitPathing', to = 'unitSelected'},
			{ name = 'clickedOtherHex', from = 'unitSelected', to = 'unitPathing' },
			{ name = 'clickedOtherHex', from = 'unitPathing', to = 'unitPathing' },
			{ name = 'reclickedOtherHex', from = 'unitPathing', to = 'unitMoving' },
			{ name = 'movingDoneAborted', from = 'unitMoving', to = 'unitPathing' },
			{ name = 'movingDoneReady', from = 'unitMoving', to = 'unitSelected' },
			{ name = 'movingDoneFinished', from = 'unitMoving', to = 'idle'},
			{ name = 'reset', from = '*', to = 'idle'}
		},
		callbacks = {
			onstatechange = function(this, event, from, to, msg)
				print('SELECTABLE SYSTEM going from ' .. from .. ' to ' .. to) 
			end,
			onclickedUnit = function(this, event, from, to, msg) 
				self:select(msg.uid)
			end,
			onenterunitSelected = function(this, event, from, to, msg) 
				print("Selecting unit (" .. msg.uid .. ") at " .. inspect(msg.address.address) .. " and my path is " .. inspect(self.path))
				self:select(self.current_selection)
				self:clearPathOverlay()
				self.path = nil
			end,
			onenteridle = function(this, event, from, to, msg)
				self:deselect()
			end,
			onleaveunitPathing = function(this, event, from, to, msg)
			end,
			onclickedOtherHex = function(this, event, from, to, msg) 
				local fromAddress = self.registry:get(self.current_selection):getComponent("Placeable").address
				local tgt = self.registry:get(msg.uid)
				local toAddress = nil
				if tgt:hasComponent("Addressable") then
					toAddress = tgt:getComponent("Addressable").address
				elseif tgt:hasComponent("Placeable") then
					toAddress = tgt:getComponent("Placeable").address
				end
				self:pathTo(fromAddress, toAddress, msg.map)
				local budget = self.registry:get(self.registry:get(self.current_selection):getComponent("Stateful").ref):getComponent("GameInfo").curr_move
				self:displayPathOverlay(msg.map, budget)
			end,
			onreclickedOtherHex = function(this, event, from, to, msg) 
				if self:moveSelectedTo(msg.uid, msg.address) then
					self.fsm:movingDoneReady(msg)
				else
					self.fsm:movingDoneAborted(msg)
				end
			end,
			onmovingDoneAborted = function(this, event, from, to, msg)
				local budget = self.registry:get(self.registry:get(self.current_selection):getComponent("Stateful").ref):getComponent("GameInfo").curr_move
				self:displayPathOverlay(msg.map, budget)
			end,
			onmovingDoneReady = function(this, event, from, to, msg) 
				self.path = nil 
			end,
			onmovingDoneFinished = function(this, event, from, to, msg) 
				self.path = nil
			end
		}
	})

	local unsubEndTurn = self.registry:subscribe("endTurn", function (this, msg)
		self.fsm:reset()
		self:clearPathOverlay()
		self:deselect()
		self.path = nil
		self.current_selection = nil
	end)
	local unsubSelect = self.registry:subscribe("selectIcon", function (this, msg)
		if self.targetCollection:has(msg.uid) then
			local selected = self.registry:get(msg.uid)
			if msg.uid == self.current_selection then
				return msg.icon_type == 'army' and self.fsm:reclickedUnit(msg) or self.fsm:reclickedOtherHex(msg)
			elseif self.path and msg.address.address == self.path[1] then
				self.fsm:reclickedOtherHex(msg)
			else
				return msg.icon_type == 'army' and (self:targetIsMineToClickOn(msg.uid) and self.fsm:clickedUnit(msg)) or self.fsm:clickedOtherHex(msg)
			end
		end
	end)

end

function SelectableSystem:targetIsMineToClickOn ( uid )
	local tgt = self.registry:get(uid)
	if tgt:hasComponent("Stateful") and tgt:hasComponent("Placeable") then
		local info = self.registry:get(tgt:getComponent("Stateful").ref):getComponent("GameInfo")
		return self.registry:findComponent("GameInfo", {gs_type="player", is_current=true}).player_name == info.owner
	end
	return false
end

function SelectableSystem:select ( gameObjectId )
	if self.current_selection ~= nil then 
		local tgtObj = self.registry:get(self.current_selection)
		local cursor = self.registry:get(self.selected_unit_cursor_object)
		self.targetCollection:detach(self.selected_unit_cursor_object, self.current_selection)
	end
	self.current_selection = gameObjectId
	if self.current_selection ~= nil then
		self:resetCursor()
		local tgtObj = self.registry:get(self.current_selection)
		self.targetCollection:attach(self.selected_unit_cursor_object, self.current_selection)
		self:centerCursor(tgtObj)
	end
end

function SelectableSystem:deselect ()
	if self.current_selection ~= nil then 
		local tgtObj = self.registry:get(self.current_selection)
		local cursor = self.registry:get(self.selected_unit_cursor_object)
		self.targetCollection:detach(self.selected_unit_cursor_object, self.current_selection)
	end
	self.current_selection = nil
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

function SelectableSystem:displayPathOverlay (map, selection_budget)
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
			local addObj = s:getComponent("Addressable")
			local cursor = nil
			for j, addressIDX in ipairs(self.path) do
				if cursor == nil and addressIDX == addObj.address then
					if self.path_costs[j] <= selection_budget then
						cursor = "CURSOR_2"
					else
						cursor = "CURSOR_1"
					end
				end
			end
			local overlay = self.registry:add(GameObject:new('Cursor',{
				Transform:new(s.x,s.y),
			    Renderable:new(
			      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			      Global.Assets:getAsset(cursor)
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

function SelectableSystem:pathTo(fromAddress, toAddress, map)
	self.path, self.path_cost, self.path_costs = map:findPath(fromAddress, toAddress)
	print("Path: " .. inspect(self.path) .. "\nTotal Cost: " .. inspect(self.path_cost) .. "\nPiecewise Costs: " .. inspect(self.path_costs))
end

function SelectableSystem:moveSelectedTo (tgtGameObjectId, tgtAddress)
	if self.current_selection ~= nil and self.current_selection ~= tgtGameObjectId then --something might be moveable
		local srcObj = self.registry:get(self.current_selection)
		local dstObj = self.registry:get(tgtGameObjectId)

		if srcObj:hasComponent('Moveable') and srcObj:hasComponent('Placeable') and dstObj:hasComponent('Addressable') then
			local mutMove = MoveArmyMutator:new(
				srcObj:getComponent('Stateful').ref, 
				srcObj:getComponent('Stateful').ref,
				dstObj:getComponent('Stateful').ref,
				srcObj:getComponent('Placeable').address, 
				dstObj:getComponent('Addressable').address, 
				self.path_cost)

			if mutMove:isValid(self.registry) then
				self.registry:publish("IMMEDIATE_MUTATE", mutMove)
				return true
			end
		end
	end
	return false
end

return SelectableSystem