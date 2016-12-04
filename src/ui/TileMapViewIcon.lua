--TileMapViewIcon.lua
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

local TileMapViewIcon = {}

TileMapViewIcon.new = function(self, registry, scenegraph, map, gamestate)
	print(registry,map)
	local gameinfo = registry:get(gamestate):getComponent("GameInfo")
	local Hex_Touch_Delegate = TouchDelegate:new();
	Hex_Touch_Delegate:setHandler('onTouch', function(this, x, y)
		if this.component.gob:hasComponent('Addressable') then
			local addr = this.component.gob:getComponent('Addressable')
			Global.PubSub:publish("pathTo",{uid = this.component.gob.uid, address = addr, map = map})
			--Global.PubSub:publish("moveTo",{uid = this.component.gob.uid, address = addr})
		end
	end)
	local debug_tile = registry:add(GameObject:new('Tile',{
		Transform:new(gameinfo.worldspace_coord[1],gameinfo.worldspace_coord[2]),
		Interfaceable:new(
			Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			Hex_Touch_Delegate),
		Renderable:new(
			Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			Global.Assets:getAsset(gameinfo.terrain_sprite)
			),
		Stateful:new(gamestate),
		Addressable:new(gameinfo.address, map)
	}))
	return debug_tile
end

return TileMapViewIcon