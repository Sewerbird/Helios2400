--Loader.lua

Renderable = require 'src/Renderable'
Interfaceable = require 'src/Interfaceable'
TouchDelegate = require 'src/TouchDelegate'
GameObject = require 'src/GameObject'
Transform = require 'src/Transform'
Polygon = require 'src/Polygon'
Sprite = require 'src/Sprite'
require 'lib/my_utils'

local Loader = class("Loader", {
	
})

function Loader:debugLoad ()

  local Debug_Spritesheet = love.graphics.newImage('assets/debug_tileset.png')
  local Debug_Hex_Quad = love.graphics.newQuad(0, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Debug_Hex2_Quad = love.graphics.newQuad(84, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Debug_Unit_Quad = love.graphics.newQuad(168, 0, 50, 50, Debug_Spritesheet:getDimensions())


  --[[ Instantiate Tilemap View ]]--

  --Make Tiles
  local Debug_Hexes = {}
  local joffset = 0
  for i = 1 , 20 do
  	for j = 1 , 10 do
  		if (i - 1) % 2 == 0 then joffset = 0 else joffset = 37 end
  		ioffset = (i-1) * -21
	  	local debug_hex = GameObject:new('Tile',{
	  		Transform:new((i-1) * 84 + ioffset, (j-1) * 73 + joffset),
		    Interfaceable:new(
		      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
		      TouchDelegate:new()),
		    Renderable:new(
		      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
		      Sprite:new(Debug_Spritesheet, Debug_Hex_Quad)
		      )
		})
		table.insert(Debug_Hexes, debug_hex)
	end
  end

  --Make Units
  local Debug_Unit = GameObject:new('Unit', {
    Transform:new(100 + 42 - 25,100 + 37 - 25),
    Interfaceable:new(
      Polygon:new({ w = 50, h = 50 }),
      TouchDelegate:new()),
    Renderable:new(
      Polygon:new({ w = 50, h = 50 }),
      Sprite:new(Debug_Spritesheet, Debug_Unit_Quad))
    })

  --Compose & Populate the layers
  local Map_Layer = GameObject:new('Map Layer', {
	  Transform:new(500,100),
  	Interfaceable:new(
  		Polygon:new({w=1200, h = 800}),
  		TouchDelegate:new())
  	})
  local Tile_Layer = GameObject:new('Tile_Layer',{})
  local Unit_Layer = GameObject:new('Unit_Layer',{})

  Map_Layer:addChildren({Tile_Layer, Unit_Layer})
  Tile_Layer:addChildren(Debug_Hexes)
  Unit_Layer:addChildren({Debug_Unit})

  local UI_Layer = GameObject:new('UI_Layer',{})

  local MapView = GameObject:new('Map_View',{})

  MapView:addChildren({Map_Layer, UI_Layer})

  print(printHeirarchy(MapView, '', ''))


  return MapView

end

return Loader