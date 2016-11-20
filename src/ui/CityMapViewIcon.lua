--CityMapViewIcon.lua
local Renderable = require 'src/component/Renderable'
local Addressable = require 'src/component/Addressable'
local Placeable = require 'src/component/Placeable'
local Interfaceable = require 'src/component/Interfaceable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local CityMapViewIcon = {}

CityMapViewIcon.new = function(self, registry, scenegraph, map, gameinfo)
	local City_Touch_Delegate = TouchDelegate:new()
	City_Touch_Delegate:setHandler('onTouch', function(this, x, y)
		if this.component.gob:hasComponent('Placeable') then
			print('Clicked on a city (' .. this.component.gob.uid .. ')! Is situated at address: ' .. map:summarizeAddress(this.component:getSiblingComponent('Placeable').address))
		end
	end)
	debug_city = registry:add(GameObject:new('City', {
		Transform:new(gameinfo.worldspace_coord[1],gameinfo.worldspace_coord[2]),
		Interfaceable:new(
			Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37}),
			City_Touch_Delegate),
		Renderable:new(
			Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
			Sprite:new(Global.Assets:getAsset("DEBUG_TILESET_1"), Global.Assets:getAsset(gameinfo.icon_sprite))
			),
		Placeable:new(gameinfo.address)
	}))
	debug_city_label = registry:add(GameObject:new('Name', {
		Transform:new(0,60),
		Renderable:new(
			Polygon:new({ w=84, h=13 }),
			nil,
			{120,120,200,200},
			gameinfo.city_name)
	}))
	scenegraph:attach(debug_city, nil)
	scenegraph:attach(debug_city_label, debug_city)

	return debug_city
end

return CityMapViewIcon