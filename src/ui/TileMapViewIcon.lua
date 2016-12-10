--TileMapViewIcon.lua
local class = require 'lib/30log'
local Renderable = require 'src/component/Renderable'
local Addressable = require 'src/component/Addressable'
local Placeable = require 'src/component/Placeable'
local Interfaceable = require 'src/component/Interfaceable'
local Stateful = require 'src/component/Stateful'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local TileMapViewIcon = class("TileMapViewIcon",{
	root = nil
})

function TileMapViewIcon:init (registry, scenegraph, map, gamestate)
	local gameinfo = registry:get(gamestate):getComponent("GameInfo")
	local Hex_Touch_Delegate = TouchDelegate:new();
	Hex_Touch_Delegate:setHandler('onTouch', function(this, x, y)
		if this.component.gob:hasComponent('Addressable') then
			local addr = this.component.gob:getComponent('Addressable')
			registry:publish("pathTo",{uid = this.component.gob.uid, address = addr, map = map})
			--registry:publish("moveTo",{uid = this.component.gob.uid, address = addr})
		end
	end)
	self.root = registry:add(GameObject:new('Tile',{
		Transform:new(gameinfo.worldspace_coord[1],gameinfo.worldspace_coord[2]),
		Interfaceable:new(
			Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			Hex_Touch_Delegate),
		Renderable:new(
			Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			Global.Assets:getAsset(gameinfo.terrain_sprite)
			),
		Stateful:new(gamestate),
		Addressable:new(gameinfo.address)
	}))
end

return TileMapViewIcon