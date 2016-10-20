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
  local Grass_Hex_Quad = love.graphics.newQuad(0, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Water_Hex_Quad = love.graphics.newQuad(84, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Arctic_Hex_Quad = love.graphics.newQuad(84, 73, 84, 73, Debug_Spritesheet:getDimensions())
  local City_Quad = love.graphics.newQuad(0, 73, 84, 73, Debug_Spritesheet:getDimensions())
  local Debug_Ship_Quad = love.graphics.newQuad(168, 0, 50, 50, Debug_Spritesheet:getDimensions())
  local Debug_Troop_Quad = love.graphics.newQuad(218, 0, 50, 50, Debug_Spritesheet:getDimensions())


  --[[ Instantiate Tilemap View ]]--

  --Make Tiles
  local Debug_Hexes = {}
  local Debug_Citys = {}
  local Debug_Units = {}

  local joffset = 0
  for i = 1 , 20 do
  	for j = 1 , 10 do
  		if (i - 1) % 2 == 0 then joffset = 0 else joffset = 37 end
  		ioffset = (i-1) * -21

      local hex = nil
      local r = math.random()
      if j == 1 or j == 10 then hex = Arctic_Hex_Quad
      elseif r < 0.30 then 
        hex = Grass_Hex_Quad
        if math.random() < 0.1 then
          local debug_city = GameObject:new('City', {
            Transform:new((i-1) * 84 + ioffset, (j-1) * 73 + joffset),
            Interfaceable:new(
              Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37}),
              TouchDelegate:new()),
            Renderable:new(
              Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
              Sprite:new(Debug_Spritesheet, City_Quad)
              )
            })
          table.insert(Debug_Citys, debug_city)
        end
        if math.random() < 0.1 then
          local debug_unit = GameObject:new('Troop', {
            Transform:new((i-1) * 84 + ioffset + 17, (j-1) * 73 + joffset + 13),
            Interfaceable:new(
              Polygon:new({ w = 50, h = 50 }),
              TouchDelegate:new()),
            Renderable:new(
              Polygon:new({ w = 50, h = 50 }),
              Sprite:new(Debug_Spritesheet, Debug_Troop_Quad))
            })
          table.insert(Debug_Units, debug_unit)
        end
      else 
        hex = Water_Hex_Quad 
        if math.random() < 0.1 then
          local debug_unit = GameObject:new('Ship', {
            Transform:new((i-1) * 84 + ioffset + 17, (j-1) * 73 + joffset + 13),
            Interfaceable:new(
              Polygon:new({ w = 50, h = 50 }),
              TouchDelegate:new()),
            Renderable:new(
              Polygon:new({ w = 50, h = 50 }),
              Sprite:new(Debug_Spritesheet, Debug_Ship_Quad))
            })
          table.insert(Debug_Units, debug_unit)
        end
      end

	  	local debug_hex = GameObject:new('Tile',{
	  		Transform:new((i-1) * 84 + ioffset, (j-1) * 73 + joffset),
		    Interfaceable:new(
		      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
		      TouchDelegate:new()),
		    Renderable:new(
		      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
		      Sprite:new(Debug_Spritesheet, hex)
		      )
  		})
  		table.insert(Debug_Hexes, debug_hex)
	  end
  end

  --Compose & Populate the layers
  local Map_Layer_Touch_Delegate = TouchDelegate:new();
  Map_Layer_Touch_Delegate:setHandler('onDrag', function(this, x,y,dx,dy)
      if this.component.gob:hasComponent('Transform') then
        print(x,y,dx,dy)
        local t = this.component.gob:getComponent('Transform')
        t:translate(dx,dy)
      end
    end)
  local Map_Layer = GameObject:new('Map Layer', {
	  Transform:new(500,100),
  	Interfaceable:new(
  		Polygon:new({w=1200, h = 800}),
  		Map_Layer_Touch_Delegate)
  	})
  local Tile_Layer = GameObject:new('Tile_Layer',{})
  local City_Layer = GameObject:new('City_Layer',{})
  local Unit_Layer = GameObject:new('Unit_Layer',{})

  Map_Layer:addChildren({Tile_Layer, City_Layer, Unit_Layer})
  Tile_Layer:addChildren(Debug_Hexes)
  City_Layer:addChildren(Debug_Citys)
  Unit_Layer:addChildren(Debug_Units)

  local UI_Layer = GameObject:new('UI_Layer',{})

  local MapView = GameObject:new('Map_View',{})

  MapView:addChildren({Map_Layer, UI_Layer})

  print(printHeirarchy(MapView, '', ''))


  return MapView

end

return Loader