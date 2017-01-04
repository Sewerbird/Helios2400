--SelectableSystem.lua
local statemachine = require 'lib/statemachine'

local System = require 'src/System'
local GameObject = require 'src/GameObject'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
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
	self.selected_unit_cursor_object = self.registry:make('Cursor',{
		Transform:new(0,0),
	    Renderable:new(
	      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
	      Global.Assets:getAsset("ANIM_CURSOR_1")
	      )
	})
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
			{ name = 'movingDoneAborted', from = 'unitMoving', to = 'unitSelected' },
			{ name = 'movingDoneReady', from = 'unitMoving', to = 'unitSelected' },
			{ name = 'movingDoneFinished', from = 'unitMoving', to = 'idle'},
			{ name = 'reset', from = '*', to = 'idle'}
		},
		callbacks = {
			onstatechange = function(this, event, from, to, msg)
				print('\27[31mSELECTABLE SYSTEM going from ' .. from .. ' to ' .. to .. ' in response to ' .. event ..'\27[0m') 
			end,
			onclickedUnit = function(this, event, from, to, msg) 
				self:select(msg.uid)
				local onBecomesInvalid
				onBecomesInvalid = self.registry:subscribe(msg.uid .. ":Removed", function(this, evt)
					print("Resetting due to removal on selectable?")
					if msg.uid == self.current_selection then
						print("YES!")
						self.fsm:reset()
						self:clearPathOverlay()
						self.path = nil
						onBecomesInvalid()
					end
				end)
			end,
			onenterunitSelected = function(this, event, from, to, msg) 
				print("Selecting unit (" .. msg.uid .. ") at " .. inspect(msg.address) .. " and my path is " .. inspect(self.path))
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
				local fromAddress = self.registry:get(self.current_selection, 'Stateful.ref.GameInfo.address')
				local toAddress = self.registry:get(msg.uid, 'Stateful.ref.GameInfo.address')

				self:pathTo(fromAddress, toAddress, self.registry:view("Earth"))
				local budget = self.registry:get(self.current_selection, 'Stateful.ref.GameInfo.curr_move')
				self:displayPathOverlay(msg.map, budget)
			end,
			onreclickedOtherHex = function(this, event, from, to, msg)
				for j,v in ipairs(self.path_costs) do
					i = #self.path_costs - (j - 1)
					if i > 1 then
						local cost = self.path_costs[j] - (self.path_costs[j + 1] or 0)
						local cs = self.registry:get(self.current_selection)
						local army = self.registry:get(self.current_selection,'Stateful.ref.GameInfo')
						self:moveArmyFromTo(army, self.path[i], self.path[i-1], cost)
					end
				end
				self.fsm:movingDoneReady(msg)
			end,
			onmovingDoneAborted = function(this, event, from, to, msg)
				local budget = self.registry:get(self.current_selection,"Stateful.ref.GameInfo.curr_move")
				self:displayPathOverlay(msg.map, budget)
			end,
			onmovingDoneReady = function(this, event, from, to, msg) 
				self.path = nil 
				if self.registry:get(self.current_selection,"Stateful.ref.GameInfo.curr_move") == 0 then
					self.fsm:reset()
				end
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
			print('selecting ' .. inspect(msg) .. ' and current selection is ' .. inspect(self.current_selection) .. 'and a path ' .. inspect(self.path))
			local selected = self.registry:get(msg.uid)
			if msg.uid == self.current_selection then
				return msg.icon_type == 'army' and self.fsm:reclickedUnit(msg) or self.fsm:reclickedOtherHex(msg)
			elseif self.path and msg.address == self.path[1] then
				self.fsm:reclickedOtherHex(msg)
			else
				return msg.icon_type == 'army' and (self:targetIsMineToClickOn(msg.uid) and self.fsm:clickedUnit(msg)) or self.fsm:clickedOtherHex(msg)
			end
		end
	end)

end

function SelectableSystem:targetIsMineToClickOn ( uid )

	local curr_player = self.registry:find('GameInfo', {gs_type="player", is_current=true}).player_name
	local tgt_player = self.registry:get(uid,'Stateful.ref.GameInfo.owner')
	print("During 'mine to click on', current player is " .. tostring(curr_player) .. " and clicked on has owner " .. tostring(tgt_player))
	return self.registry:get(uid,'Stateful') 
		and curr_player == tgt_player
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
		self:centerCursor(self.current_selection)
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
	self.registry:get(self.selected_unit_cursor_object, 'Transform'):teleport(0,0)
	self:clearPathOverlay()
end

function SelectableSystem:centerCursor ( gameObject )
	local tgtRenderable = self.registry:get(gameObject, 'Renderable')
	if tgtRenderable then
		local cursorpoly = self.registry:get(self.selected_unit_cursor_object, 'Renderable').polygon
		self.registry:get(self.selected_unit_cursor_object, 'Transform'):translate( tgtRenderable.polygon.w/2 - cursorpoly.w/2 ,  tgtRenderable.polygon.h/2 - cursorpoly.h/2)
	end
end

function SelectableSystem:displayPathOverlay (map, selection_budget)
	if not self.path then return end
	self:clearPathOverlay()

	for i, address in ipairs(self.path) do
		local t_ref = self.registry:find("GameInfo",{gs_type = "tile", address = address}).gid
		local s = self.registry:find("Stateful", {tgt = t_ref})
		if s ~= nil then
			local tileTransform = self.registry:get(s.gid, "Transform")
			local cursor = nil
			for j, addressIDX in ipairs(self.path) do
				if cursor == nil and addressIDX == address then
					if self.path_costs[j] <= selection_budget then
						cursor = "CURSOR_2"
					else
						cursor = "CURSOR_1"
					end
				end
			end
			local overlay = self.registry:make('Cursor',{
				Transform:new(0,0),
			    Renderable:new(
			      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			      Global.Assets:getAsset(cursor)
			      )
			})
			table.insert(self.path_overlays, overlay)
			self.targetCollection:attach(overlay,s.gid)
		end
	end
end

function SelectableSystem:clearPathOverlay ()
	if self.path_overlays then
		for i, overlay in ipairs(self.path_overlays) do
			self.targetCollection:detach(overlay)
			self.registry:destroy(overlay)
		end
		self.path_overlays = {}
	end
end

function SelectableSystem:pathTo(fromAddress, toAddress, map)
	if fromAddress == nil or toAddress == nil then 
		print("WARNING: pathTo called with a nil address - from " .. tostring(fromAddress) .. ' to ' .. tostring(toAddress))
		return
	end
	self.path, self.path_cost, self.path_costs = map:findPath(fromAddress, toAddress)
	print("Path: " .. inspect(self.path) .. "\nTotal Cost: " .. inspect(self.path_cost) .. "\nPiecewise Costs: " .. inspect(self.path_costs))
end

function SelectableSystem:moveArmyFromTo (armyInfo, fromAddress, tgtAddress, cost)
	if armyInfo and tgtAddress ~= armyInfo.address then --something might be moveable
		print("Issuing moveArmyTo to go from " .. tostring(fromAddress) .. "to" .. tostring(tgtAddress) .." with " .. armyInfo.curr_move .. " against cost " .. cost)
			
		local mutMove = MoveArmyMutator:new(
			armyInfo.gid,
			fromAddress, 
			tgtAddress, 
			cost)

		if mutMove:isValid(self.registry) and not armyInfo.is_destroyed then
			return mutMove:apply(self.registry)
		end
	elseif armyInfo then
	end
end

return SelectableSystem