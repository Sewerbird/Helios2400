--Loader.lua
require 'lib/my_utils'
local Renderable = require 'src/component/Renderable'
local Addressable = require 'src/component/Addressable'
local Placeable = require 'src/component/Placeable'
local Interfaceable = require 'src/component/Interfaceable'
local Moveable = require 'src/component/Moveable'
local Updateable = require 'src/component/Updateable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameInfo = require 'src/component/GameInfo'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'
local HexCoord = require 'src/datatype/HexCoord'
local Registry = require 'src/structure/Registry'
local IndexTree = require 'src/structure/IndexTree'
local IndexMap = require 'src/structure/IndexMap'
local MapView = require 'src/ui/MapView'
local CityMapViewIcon = require 'src/ui/CityMapViewIcon'
local ArmyMapViewIcon = require 'src/ui/ArmyMapViewIcon'
local TileMapViewIcon = require 'src/ui/TileMapViewIcon'
local class = require 'lib/30log'

local Loader = class("Loader", {
	
})

function Loader:debugLoad ()

  --[[ Load Assets ]]--
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


  --[[ Generate the Game State ]]--
  local debug_gamestate = Global.Registry--TODO: make this with a Registry:new();
  local city_names = {'New Moroni', 'Tiangong', 'Elonia', 'Neokyoto', 'Al Kicab', 'Choaswell', 'Atraapool', 'Efrimirie', 'Droawona'}
  local joffset = 0
  local num_rows = 12
  local num_cols = 24
  local Earth_Map = IndexMap:new()

  for i = 1 , num_cols do --x
    for j = 1 , num_rows do
      if (i - 1) % 2 == 0 then joffset = 0 else joffset = 37 end
      local ioffset = (i-1) * -21
      local hex = (j==1 or j==num_rows) and Arctic_Hex_Quad or ((math.random() < 0.3) and Grass_Hex_Quad or Water_Hex_Quad)

      local hex_info = {
        map = 'Earth',
        address = 'Earth' .. HexCoord:new(i,j):toString(),
        terrain_sprite = hex,
        neighbors = {
          'Earth' .. HexCoord:new(i,j-1):toString(),
          'Earth' .. HexCoord:new(i,j+1):toString(),
          (j % 2 == 0) and 'Earth' .. HexCoord:new(i-1,j+1):toString() or 'Earth' .. HexCoord:new(i-1,j-1):toString(),
          (j % 2 == 0) and 'Earth' .. HexCoord:new(i+1,j+1):toString() or 'Earth' .. HexCoord:new(i+1,j-1):toString(),
          'Earth' .. HexCoord:new(i-1,j):toString(),
          'Earth' .. HexCoord:new(i+1,j):toString()
        },
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset}
      }
      local city_info = (hex == Grass_Hex_Quad and math.random() < 0.15) and {
        city_name = city_names[math.floor(math.random()*#city_names)+1],
        address = hex_info.address,
        icon_sprite = City_Quad,
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset}
      } or nil
      local army_info = (hex == Grass_Hex_Quad and math.random() < 0.13) and {
        team_color = (math.random() > 0.5) and {60,60,200,200} or {200,60,60,200},
        icon_sprite = Debug_Troop_Quad,
        curr_hp = math.floor(math.random() * 100),
        max_hp = 100,
        army_type = 'stealth',
        army_name = (math.floor(math.random()*10)) .. "th Army",
        personel_cnt = math.floor(math.random() * 10),
        assault_rating = 4,
        defense_rating = 3,
        address = hex_info.address,
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset}
      } or nil

      local oHex = debug_gamestate:add(GameObject:new('gsHex',{GameInfo:new(hex_info)}))
      local oCity = city_info and debug_gamestate:add(GameObject:new('gsCity',{GameInfo:new(city_info)})) or nil
      local oArmy = army_info and debug_gamestate:add(GameObject:new('gsArmy',{GameInfo:new(army_info)})) or nil

      Earth_Map:addAddress(hex_info.address, hex_info.neighbors, {oCity, oArmy})
    end
  end
  ----[[Instantiate Tilemap View ]]--

  local SceneGraph = IndexTree:new();
  local Earth_Tiles = {}
  local Earth_Cities = {}
  local Earth_Units = {}

  for i, obj in ipairs(debug_gamestate.registry) do
    local tgt = obj:getComponent("GameInfo")
    local nxt = nil
    if obj.description == 'gsHex' then
      table.insert(Earth_Tiles, TileMapViewIcon:new(debug_gamestate,SceneGraph,Earth_Map,obj:getComponent("GameInfo"),Debug_Spritesheet))
    elseif obj.description == 'gsCity' then
      table.insert(Earth_Cities, CityMapViewIcon:new(debug_gamestate,SceneGraph,Earth_Map,obj:getComponent("GameInfo"),Debug_Spritesheet))
    elseif obj.description == 'gsArmy' then
      table.insert(Earth_Units, ArmyMapViewIcon:new(debug_gamestate,SceneGraph,Earth_Map,obj:getComponent("GameInfo"),Debug_Spritesheet))
    end
  end

  local Earth_View = MapView:new(debug_gamestate, SceneGraph, Earth_Map, Earth_Tiles, Earth_Cities, Earth_Units)

  return SceneGraph
end

return Loader