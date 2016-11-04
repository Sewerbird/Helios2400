--Loader.lua

Renderable = require 'src/Renderable'
Addressable = require 'src/Addressable'
Placeable = require 'src/Placeable'
Interfaceable = require 'src/Interfaceable'
TouchDelegate = require 'src/TouchDelegate'
GameObject = require 'src/GameObject'
Transform = require 'src/Transform'
Polygon = require 'src/Polygon'
Sprite = require 'src/Sprite'
HexCoord = require 'src/HexCoord'
GameObjectRegistry = require 'src/GameObjectRegistry'
Collection = require 'src/Collection'
InterfaceableSystem = require 'src/InterfaceableSystem'
RenderableSystem = require 'src/RenderableSystem'
SelectableSystem = require 'src/SelectableSystem'

require 'lib/my_utils'
local class = require 'lib/30log'

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
  local Debug_Cursor_Quad = love.graphics.newQuad(0, 146, 84, 73, Debug_Spritesheet:getDimensions())

  Global = {
    Registry = GameObjectRegistry:new(),
    Systems = {}
  }
  --[[ Instantiate Tilemap View ]]--

  --Make Tiles
  local Debug_Hexes = {}
  local Debug_Citys = {}
  local Debug_Units = {}

  local joffset = 0
  local num_rows = 10
  local num_cols = 20
  local idx = 1

  for i = 1 , num_cols do --x
  	for j = 1 , num_rows do --y
  		if (i - 1) % 2 == 0 then joffset = 0 else joffset = 37 end
  		ioffset = (i-1) * -21

      local neighbors   
      if j % 2 == 1 then
        neighbors = {
          HexCoord:new(i,j-1):toString(),
          HexCoord:new(i,j+1):toString(),
          HexCoord:new(i-1,j+1):toString(),
          HexCoord:new(i+1,j+1):toString(),
          HexCoord:new(i-1,j):toString(),
          HexCoord:new(i+1,j):toString()
          }
      else
        neighbors = {
          HexCoord:new(i,j-1):toString(),
          HexCoord:new(i,j+1):toString(),
          HexCoord:new(i-1,j-1):toString(),
          HexCoord:new(i+1,j-1):toString(),
          HexCoord:new(i-1,j):toString(),
          HexCoord:new(i+1,j):toString()
          }
      end

      local address = 'Earth' .. HexCoord:new(i,j):toString()
      local addressable = Addressable:new(address, neighbors)

      local Unit_Touch_Delegate = TouchDelegate:new()
      Unit_Touch_Delegate:setHandler('onTouch', function(this, x, y)
        if this.component.gob:hasComponent('Placeable') then
          print('Clicked on a unit!')
          Global.Systems.Selection:select(this.component.gob.uid)
        end
      end)
      local City_Touch_Delegate = TouchDelegate:new()
      City_Touch_Delegate:setHandler('onTouch', function(this, x, y)
        if this.component.gob:hasComponent('Placeable') then
          print('Clicked on a city!')
          Global.Systems.Selection:select(this.component.gob.uid)
        end
      end)

      local hex = nil
      local r = math.random()
      if j == 1 or j == num_rows then hex = Arctic_Hex_Quad
      elseif r < 0.30 then 
        hex = Grass_Hex_Quad
        if math.random() < 0.3 then
          local debug_city = Global.Registry:add(GameObject:new('City', {
            Transform:new((i-1) * 84 + ioffset, (j-1) * 73 + joffset),
            Interfaceable:new(
              Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37}),
              City_Touch_Delegate),
            Renderable:new(
              Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
              Sprite:new(Debug_Spritesheet, City_Quad)
              ),
            Placeable:new(address)
          }))
          table.insert(Debug_Citys, debug_city)
        end
        if math.random() < 0.3 then
          local debug_unit = Global.Registry:add(GameObject:new('Troop', {
            Transform:new((i-1) * 84 + ioffset + 17, (j-1) * 73 + joffset + 13),
            Interfaceable:new(
              Polygon:new({ w = 50, h = 50 }),
              Unit_Touch_Delegate),
            Renderable:new(
              Polygon:new({ w = 50, h = 50 }),
              Sprite:new(Debug_Spritesheet, Debug_Troop_Quad)),
            Placeable:new(address)
          }))
          table.insert(Debug_Units, debug_unit)
        end
      else 
        hex = Water_Hex_Quad 
        if math.random() < 0.1 then
          local debug_unit = Global.Registry:add(GameObject:new('Ship', {
            Transform:new((i-1) * 84 + ioffset + 17, (j-1) * 73 + joffset + 13),
            Interfaceable:new(
              Polygon:new({ w = 50, h = 50 }),
              Unit_Touch_Delegate),
            Renderable:new(
              Polygon:new({ w = 50, h = 50 }),
              Sprite:new(Debug_Spritesheet, Debug_Ship_Quad)),
            Placeable:new(address)
          }))
          table.insert(Debug_Units, debug_unit)
        end
      end

      local Hex_Touch_Delegate = TouchDelegate:new();
      Hex_Touch_Delegate:setHandler('onTouch', function(this, x, y)
          if this.component.gob:hasComponent('Addressable') then
            local addr = this.component.gob:getComponent('Addressable')
            print('hex has neighbors ' .. inspect(addr.neighbors))
          end
        end)
	  	local debug_hex = Global.Registry:add(GameObject:new('Tile',{
	  		Transform:new((i-1) * 84 + ioffset, (j-1) * 73 + joffset),
		    Interfaceable:new(
		      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
		      Hex_Touch_Delegate),
		    Renderable:new(
		      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
		      Sprite:new(Debug_Spritesheet, hex)
		      ),
        addressable
  		}))
  		table.insert(Debug_Hexes, debug_hex)

      idx = idx + 1
	  end
  end

  --Compose & Populate the layers
  local Map_Layer_Touch_Delegate = TouchDelegate:new();
  Map_Layer_Touch_Delegate:setHandler('onDrag', function(this, x,y,dx,dy)
      if this.component.gob:hasComponent('Transform') then
        local t = this.component.gob:getComponent('Transform')
        t:translate(dx,dy)
      end
    end)
  local Map_Layer = Global.Registry:add(GameObject:new('Map Layer', {
	  Transform:new(500,100),
  	Interfaceable:new(
  		Polygon:new({w=1200, h = 800}),
  		Map_Layer_Touch_Delegate)
  	}))


  local SceneGraph = Collection:new();

  local MapView = Global.Registry:add(GameObject:new('Map_View',{}))
  local Tile_Layer = Global.Registry:add(GameObject:new('Tile_Layer',{}))
  local City_Layer = Global.Registry:add(GameObject:new('City_Layer',{}))
  local Unit_Layer = Global.Registry:add(GameObject:new('Unit_Layer',{}))
  local UI_Layer = Global.Registry:add(GameObject:new('UI_Layer',{}))

  SceneGraph:attach(MapView)
  SceneGraph:attachAll({Map_Layer,UI_Layer}, MapView)
  SceneGraph:attachAll({Tile_Layer,City_Layer,Unit_Layer,UI_Layer}, Map_Layer)
  SceneGraph:attachAll(Debug_Hexes, Tile_Layer)
  SceneGraph:attachAll(Debug_Citys, City_Layer)
  SceneGraph:attachAll(Debug_Units, Unit_Layer)


  Global.Systems.Render = RenderableSystem:new(SceneGraph)
  Global.Systems.Interface = InterfaceableSystem:new(SceneGraph)
  Global.Systems.Selection = SelectableSystem:new(SceneGraph, Sprite:new(Debug_Spritesheet, Debug_Cursor_Quad))

  Global.Systems.Selection:select(2)
  

end

return Loader