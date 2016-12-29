--TileMapViewIcon.lua
local class = require 'lib/30log'
local Renderable = require 'src/component/Renderable'
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
		registry:publish("selectIcon",{uid = this.component.gob.uid, address = registry:get(this.component:getSiblingComponent('Stateful').ref):getComponent("GameInfo").address, gamestate = gamestate, icon_type = 'tile'})
		--registry:publish("moveTo",{uid = this.component.gob.uid, address = addr})
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
		Stateful:new(gamestate)
	}))
	if gameinfo.decorations then
		scenegraph:attach(self.root, nil)
		for i, deco in ipairs(gameinfo.decorations) do
			local decor = registry:add(GameObject:new('Tile_Decor',{
				Transform:new(0,0),
				Renderable:new(
					Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37}),
					Global.Assets:getAsset(deco))
				}))
			scenegraph:attach(decor, self.root)
		end
		scenegraph:detach(self.root)
	end
end

return TileMapViewIcon