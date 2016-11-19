--Loader.lua

Renderable = require 'src/component/Renderable'
Addressable = require 'src/component/Addressable'
Placeable = require 'src/component/Placeable'
Interfaceable = require 'src/component/Interfaceable'
Moveable = require 'src/component/Moveable'
Updateable = require 'src/component/Updateable'
Transform = require 'src/component/Transform'
TouchDelegate = require 'src/datatype/TouchDelegate'
GameObject = require 'src/GameObject'
Polygon = require 'src/datatype/Polygon'
Sprite = require 'src/datatype/Sprite'
HexCoord = require 'src/datatype/HexCoord'
Registry = require 'src/structure/Registry'
IndexTree = require 'src/structure/IndexTree'
IndexMap = require 'src/structure/IndexMap'

require 'lib/my_utils'
local class = require 'lib/30log'

local Loader = class("Loader", {
	
})

function Loader:debugLoad ()

  local Debug_Spritesheet = love.graphics.newImage('assets/debug_tileset.png')
  local Grass_Hex_Quad = love.graphics.newQuad(0, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Water_Hex_Quad = love.graphics.newQuad(84, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Arctic_Hex_Quad = love.graphics.newQuad(84, 73, 84, 73, Debug_Spritesheet:getDimensions())
  local Space_Hex_Quad = love.graphics.newQuad(84, 146, 84, 73, Debug_Spritesheet:getDimensions())
  local Planet_1_Quad = love.graphics.newQuad(168, 146, 84, 73, Debug_Spritesheet:getDimensions())
  local Planet_2_Quad = love.graphics.newQuad(252, 146, 84, 73, Debug_Spritesheet:getDimensions())
  local City_Quad = love.graphics.newQuad(0, 73, 84, 73, Debug_Spritesheet:getDimensions())
  local Debug_Ship_Quad = love.graphics.newQuad(168, 0, 50, 50, Debug_Spritesheet:getDimensions())
  local Debug_Troop_Quad = love.graphics.newQuad(218, 0, 50, 50, Debug_Spritesheet:getDimensions())
  local Debug_Cursor_Quad = love.graphics.newQuad(0, 146, 84, 73, Debug_Spritesheet:getDimensions())
  local Debug_Spaceship_Quad = love.graphics.newQuad(218, 80, 50, 50, Debug_Spritesheet:getDimensions())

  local music = love.audio.newSource('assets/music/Ritual.mp3')
  music:setLooping(true)
  music:setVolume(BG_MUSIC_VOL)
  music:play()

  local space_map = IndexMap:new()
  local earth_map = IndexMap:new()

  --[[ Instantiate Tilemap View ]]--

  local joffset = 0
  local num_rows = 12
  local num_cols = 24

  --Earth Map

  local SceneGraph = IndexTree:new();

  local Earth_Hexes = {}
  local Earth_Citys = {}
  local Earth_Units = {}

  local city_names = {'New Moroni', 'Tiangong', 'Elonia', 'Neokyoto', 'Al Kicab'}

  for i = 1 , num_cols do --x
  	for j = 1 , num_rows do --y
  		if (i - 1) % 2 == 0 then joffset = 0 else joffset = 37 end
  		local ioffset = (i-1) * -21

      local neighbors   
      if j % 2 == 1 then
        neighbors = {
          'Earth' .. HexCoord:new(i,j-1):toString(),
          'Earth' .. HexCoord:new(i,j+1):toString(),
          'Earth' .. HexCoord:new(i-1,j+1):toString(),
          'Earth' .. HexCoord:new(i+1,j+1):toString(),
          'Earth' .. HexCoord:new(i-1,j):toString(),
          'Earth' .. HexCoord:new(i+1,j):toString()
          }
      else
        neighbors = {
          'Earth' .. HexCoord:new(i,j-1):toString(),
          'Earth' .. HexCoord:new(i,j+1):toString(),
          'Earth' .. HexCoord:new(i-1,j-1):toString(),
          'Earth' .. HexCoord:new(i+1,j-1):toString(),
          'Earth' .. HexCoord:new(i-1,j):toString(),
          'Earth' .. HexCoord:new(i+1,j):toString()
          }
      end

      local address = 'Earth' .. HexCoord:new(i,j):toString()
      local Unit_Touch_Delegate = TouchDelegate:new()
      Unit_Touch_Delegate:setHandler('onTouch', function(this, x, y)
        if this.component.gob:hasComponent('Placeable') then
          print('TODO: SHOULD BROADCAST A SELECT ON ' .. this.component.gob.uid) -- Global.Systems.Selection:select(this.component.gob.uid)
          Global.PubSub:publish("select",{uid = this.component.gob.uid})
          print('Clicked on a unit (' .. this.component.gob.uid .. ')! Is situated at address:' .. earth_map:summarizeAddress(earth_map:findPlaceableAddress(this.component.gob.uid)))
          return true
        end
      end)
      local City_Touch_Delegate = TouchDelegate:new()
      City_Touch_Delegate:setHandler('onTouch', function(this, x, y)
        if this.component.gob:hasComponent('Placeable') then
          print('TODO: SHOULD BROADCAST A SELECT ON ' .. this.component.gob.uid) -- Global.Systems.Selection:select(this.component.gob.uid)
          --Global.PubSub:publish("select",{uid = this.component.gob.uid})
          print('Clicked on a city (' .. this.component.gob.uid .. ')! Is situated at address: ' .. earth_map:summarizeAddress(earth_map:findPlaceableAddress(this.component.gob.uid)))
          --return true
        end
      end)

      local hex = nil
      local debug_unit = nil
      local debug_city = nil
      local r = math.random()
      if j == 1 or j == num_rows then hex = Arctic_Hex_Quad
      elseif r < 0.30 then 
        hex = Grass_Hex_Quad
        local planet = nil
        if math.random() < 0.15 then
          local city = City_Quad
          debug_city = Global.Registry:add(GameObject:new('City', {
            Transform:new((i-1) * 84 + ioffset, (j-1) * 73 + joffset),
            Interfaceable:new(
              Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37}),
              City_Touch_Delegate),
            Renderable:new(
              Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
              Sprite:new(Debug_Spritesheet, city)
              ),
            Placeable:new(address)
          }))
          debug_city_label = Global.Registry:add(GameObject:new('Name', {
            Transform:new(0,60),
            Renderable:new(
              Polygon:new({ w=84, h=13 }),
              nil,
              {120,120,200,200},
              city_names[math.floor(math.random()*#city_names)+1])
            }))
          SceneGraph:attach(debug_city, nil)
          SceneGraph:attach(debug_city_label, debug_city)
          table.insert(Earth_Citys, debug_city)

        end
        if math.random() < 0.13 then
          --DEBUG LAND ARMY
          local team_color = {200,60,60,200}
          if math.random() > 0.5 then team_color = {60,60,200,200} end
          debug_unit = Global.Registry:add(GameObject:new('Army', {
            Transform:new((i-1) * 84 + ioffset, (j-1) * 73 + joffset),
            Interfaceable:new(
              Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73, 0,37}),
              Unit_Touch_Delegate),
            Placeable:new(address),
            Moveable:new()
          }))
          debug_unit_bg = Global.Registry:add(GameObject:new('Army_BG', {
            Transform:new((84-50)/2, (73-50)/2),
            Renderable:new(
              Polygon:new({ w = 50, h = 50}),
              nil,
              team_color)
          }))
          debug_unit_sprite = Global.Registry:add(GameObject:new('Troop', {
            Transform:new(3,5),
            Renderable:new(
              Polygon:new({ w = 50, h = 50 }),
              Sprite:new(Debug_Spritesheet, Debug_Troop_Quad))
          }))
          debug_unit_name = Global.Registry:add(GameObject:new('Name', {
            Transform:new(-3,0),
            Renderable:new(
              nil,
              nil,
              nil,
              (math.floor(math.random()*10)) .. "th Army")
          }))
          debug_unit_health = Global.Registry:add(GameObject:new('HealthBar', {
            Transform:new(0,45),
            Renderable:new(
              Polygon:new({ w = 50 * math.random(), h=5}),
              nil,
              {100,200,100})
          }))
          debug_unit_timer = Global.Registry:add(GameObject:new('Timer', {
            Transform:new(0,15),
            Renderable:new(
              nil,
              nil,
              nil,
              "0:00"),
            Updateable:new({
              tick = function (this, msg)
                local renderable = this.gob:getComponent("Renderable")
                if renderable ~= nil then
                  renderable.text = msg.ticktext
                end
              end
            })
          }))
          SceneGraph:attach(debug_unit,nil)
          SceneGraph:attach(debug_unit_bg, debug_unit)
          SceneGraph:attachAll({debug_unit_sprite, debug_unit_name, debug_unit_health, debug_unit_timer}, debug_unit_bg)
          table.insert(Earth_Units, debug_unit)
        end
      else 
        hex = Water_Hex_Quad 
        if math.random() < 0.1 then
        end
      end
      if debug_unit ~= nil then
        if debug_city ~= nil then
          earth_map:addAddress(address, neighbors, {debug_city, debug_unit})
        else
          earth_map:addAddress(address, neighbors, {debug_unit})
        end
      else
        if debug_city ~= nil then
          earth_map:addAddress(address, neighbors, {debug_city})
        else
          earth_map:addAddress(address, neighbors, {})
        end
      end

      local Hex_Touch_Delegate = TouchDelegate:new();
      Hex_Touch_Delegate:setHandler('onTouch', function(this, x, y)
          if this.component.gob:hasComponent('Addressable') then
            local addr = this.component.gob:getComponent('Addressable')
            print('TODO: SHOULD BROADCAST A MOVE TO ' .. this.component.gob.uid)
            --Global.Systems.Selection:moveSelectedTo(this.component.gob.uid, this.component.address)
            Global.PubSub:publish("moveTo",{uid = this.component.gob.uid, address = addr})
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
        Addressable:new(address)
  		}))
  		table.insert(Earth_Hexes, debug_hex)

	  end
  end

  --Compose & Populate the layers

  local Map_Layer = Global.Registry:add(GameObject:new('Map Layer', {
    Transform:new(-60,10)
    }))
  local Map_View_Touch_Delegate = TouchDelegate:new();
  Map_View_Touch_Delegate:setHandler('onDrag', function(this, x,y,dx,dy)
    if Global.Registry:get(Map_Layer):hasComponent('Transform') then
      local t = Global.Registry:get(Map_Layer):getComponent('Transform')
      t:translate(dx,dy)
    end
  end)
  local MapView = Global.Registry:add(GameObject:new('Map_View',{
    Transform:new(0,0),
    Interfaceable:new(
      Polygon:new({w=1200, h=800}),
      Map_View_Touch_Delegate)
    }))

  


  local Tile_Layer = Global.Registry:add(GameObject:new('Tile_Layer',{}))
  local City_Layer = Global.Registry:add(GameObject:new('City_Layer',{}))
  local Unit_Layer = Global.Registry:add(GameObject:new('Unit_Layer',{}))
  local UI_Layer = Global.Registry:add(GameObject:new('UI_Layer',{}))

  SceneGraph:attach(MapView)
  SceneGraph:attachAll({Map_Layer,UI_Layer}, MapView)
  SceneGraph:attachAll({Tile_Layer,City_Layer,Unit_Layer,UI_Layer}, Map_Layer)
  SceneGraph:attachAll(Earth_Hexes, Tile_Layer)
  SceneGraph:attachAll(Earth_Citys, City_Layer)
  SceneGraph:attachAll(Earth_Units, Unit_Layer)

  return SceneGraph
end

return Loader