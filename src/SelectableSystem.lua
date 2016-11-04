--SelectableSystem.lua
local System = require 'src/System'
local Selectable = require 'src/Selectable'

local GameObject = require 'src/GameObject'
local Transform = require 'src/Transform'
local Renderable = require 'src/Renderable'
local Placeable = require 'src/Placeable'
local Polygon = require 'src/Polygon'

local SelectableSystem = System:extend({
	current_selection = nil,
	selected_unit_cursor_object = nil,
	cursor_sprite = nil
})

function SelectableSystem:init (targetCollection, cursor_sprite)
	SelectableSystem.super.init(self, targetCollection)
	self.cursor_sprite = cursor_sprite

end

function SelectableSystem:createCursor ()
	return Global.Registry:add(GameObject:new('Cursor',{
		Transform:new(0,0),
	    Renderable:new(
	      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
	      self.cursor_sprite
	      ),
	    Placeable:new()
	}))
end

function SelectableSystem:select ( gameObjectId )
	if self.selected_unit_cursor_object == nil then
		self.selected_unit_cursor_object = self:createCursor()
	end
	if self.current_selection ~= nil then 
		local tgtObj = Global.Registry:get(self.current_selection)
		local cursor = Global.Registry:get(self.selected_unit_cursor_object)
		self.targetCollection:detach(self.selected_unit_cursor_object, self.current_selection)
		--tgtObj:getComponent('Selectable'):deselect()

	end
	if self.current_selection == gameObjectId then 
		self.current_selection = nil
		return
	end
	self.current_selection = gameObjectId
	if self.current_selection ~= nil then
		local tgtObj = Global.Registry:get(self.current_selection)
		self.targetCollection:attach(self.selected_unit_cursor_object, self.current_selection)
		--tgtObj:getComponent('Selectable'):select()
	end
end

return SelectableSystem