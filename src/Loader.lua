--Loader.lua
require 'lib/my_utils'
local Renderable = require 'src/component/Renderable'
local Addressable = require 'src/component/Addressable'
local Placeable = require 'src/component/Placeable'
local Interfaceable = require 'src/component/Interfaceable'
local Moveable = require 'src/component/Moveable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameInfo = require 'src/component/GameInfo'
local GameObject = require 'src/GameObject'
local AssetLoader = require 'src/AssetLoader'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'
local Animation = require 'src/datatype/Animation'
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
  loadContext = nil
	
})

function Loader:init(context)
  self.loadContext = context
end

function Loader:debugLoad ()

  --[[ Load Assets & Play some music because why not ]]--
  local Assets = self.loadContext.Assets

  local music = Assets:getAsset("RITUAL_1")
  music:setLooping(true)
  music:setVolume(BG_MUSIC_VOL)
  music:play()

  --[[ Generate the Game State ]]--

  local debug_gamestate = Global.Registry--TODO: make this with a Registry:new();
  self:loadGame('gen_1',debug_gamestate)
  --[[
  local city_names = {'New Moroni', 'Tiangong', 'Elonia', 'Neokyoto', 'Al Kicab', 'Choaswell', 'Atraapool', 'Efrimirie', 'Droawona'}
  local joffset = 0
  local num_rows = 12
  local num_cols = 24
  local Earth_Map = IndexMap:new()

  for i = 1 , num_cols do --x
    for j = 1 , num_rows do
      if (i - 1) % 2 == 0 then joffset = 0 else joffset = 37 end
      local ioffset = (i-1) * -21
      local hex = (j==1 or j==num_rows) and "TILE_ARCTIC_1" or ((math.random() < 0.3) and "TILE_GRASS_1" or "TILE_WATER_1")

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
      local city_info = (hex == "TILE_GRASS_1" and math.random() < 0.15) and {
        city_name = city_names[math.floor(math.random()*#city_names)+1],
        address = hex_info.address,
        icon_sprite = "CITY_1",
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset}
      } or nil
      local army_info = (hex == "TILE_GRASS_1" and math.random() < 0.13) and {
        team_color = (math.random() > 0.5) and {60,60,200,200} or {200,60,60,200},
        icon_sprite = "TROOP_1",
        curr_hp = math.floor(math.random() * 100),
        max_hp = 100,
        max_move = 10,
        curr_move = 10,
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
  ]]--

  --self:saveGame('gen_1',debug_gamestate)

  --[[Instantiate Tilemap View ]]--
  local SceneGraph = IndexTree:new();
  local Earth_Tiles = {}
  local Earth_Cities = {}
  local Earth_Units = {}

  for key, obj in ipairs(debug_gamestate.registry) do
    local tgt = obj:getComponent("GameInfo")
    if obj.description == 'gsHex' then
      table.insert(Earth_Tiles, TileMapViewIcon:new(debug_gamestate,SceneGraph,Earth_Map,key))
    elseif obj.description == 'gsCity' then
      table.insert(Earth_Cities, CityMapViewIcon:new(debug_gamestate,SceneGraph,Earth_Map,key))
    elseif obj.description == 'gsArmy' then
      table.insert(Earth_Units, ArmyMapViewIcon:new(debug_gamestate,SceneGraph,Earth_Map,key))
    end
  end

  local Earth_View = MapView:new(debug_gamestate, SceneGraph, Earth_Map, Earth_Tiles, Earth_Cities, Earth_Units)

  return SceneGraph
end

function Loader:saveGame ( name, gamestateRegistry)
  local serialized_gamestate = {}
  for i = 1, #gamestateRegistry.registry do
    local obj = gamestateRegistry.registry[i]
    if obj:hasComponent("GameInfo") then
      table.insert(serialized_gamestate, obj:getComponent("GameInfo"):serialize())
    end
  end
  love.filesystem.write((name .. '.sav'), Tserial.pack(serialized_gamestate))
end

function Loader:loadGame( name, registry)
  local contents, size = love.filesystem.read((name .. '.sav'))
  local raw_save = Tserial.unpack(contents)
  for i = 1, #raw_save do
    local obj = GameInfo:reify(raw_save[i])
    print(inspect(obj))
    registry:add(obj)
  end
end

return Loader