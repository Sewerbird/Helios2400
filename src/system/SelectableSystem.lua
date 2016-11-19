--SelectableSystem.lua
local System = require 'src/System'
local GameObject = require 'src/GameObject'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
local Placeable = require 'src/component/Placeable'
local Polygon = require 'src/datatype/Polygon'

local SelectableSystem = System:extend({
	current_selection = nil,
	selected_unit_cursor_object = nil
})

function SelectableSystem:init (registry, targetCollection, cursor_sprite)
	SelectableSystem.super.init(self, registry, targetCollection)
	--TODO: use AssetLoader
	local Debug_Spritesheet = love.graphics.newImage('assets/debug_tileset.png')
	local Debug_Cursor_Quad = love.graphics.newQuad(0, 146, 84, 73, Debug_Spritesheet:getDimensions())
	self.selected_unit_cursor_object = self.registry:add(GameObject:new('Cursor',{
		Transform:new(0,0),
	    Renderable:new(
	      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
	      Sprite:new(Debug_Spritesheet, Debug_Cursor_Quad)
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

			--we can move this thing
			local plc = srcObj:getComponent('Placeable')
			local adr = dstObj:getComponent('Addressable')
			local dst_transform = dstObj:getComponent('Transform')
			local dst_poly = dstObj:getComponent('Interfaceable').polygon
			local src_poly = srcObj:getComponent('Interfaceable').polygon

			plc.address = adr.address
			srcObj:getComponent('Transform'):teleport(dst_transform.x + dst_poly.w/2 - src_poly.w/2, dst_transform.y + dst_poly.h/2 - src_poly.h/2)
		else
			self:select(tgtGameObjectId)
		end
	else
		print('selecting')
		self:select(tgtGameObjectId)
	end
end

return SelectableSystem