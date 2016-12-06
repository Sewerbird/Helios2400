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
local Registry = require 'src/Registry'
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

function Loader:debugGenerateEarthMap (debug_gamestate)
  local city_names = {'New Moroni', 'Tiangong', 'Elonia', 'Neokyoto', 'Al Kicab', 'Choaswell', 'Atraapool', 'Efrimirie', 'Droawona'}
  local joffset = 0
  local num_rows = 12
  local num_cols = 24

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
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset},
        terrain_info = {
          land = math.random(7),
          sea = math.random(8),
          aero = math.random(4),
          hover = math.random(6),
          space = math.random(3),
          reentry = math.random(10),
          toxic = false,--math.random() > 0.8,
          vacuum = false,--math.random() > 0.8,
          shielded = false,--math.random() > 0.8,
        }
      }
      local city_info = (hex == "TILE_GRASS_1" and math.random() < 0.15) and {
        city_name = city_names[math.floor(math.random()*#city_names)+1],
        map = 'Earth',
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
        map = 'Earth',
        mov_type = "ground",
        address = hex_info.address,
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset}
      } or nil

      local oHex = debug_gamestate:add(GameObject:new('gsHex',{GameInfo:new(hex_info)}))
      local oCity = city_info and debug_gamestate:add(GameObject:new('gsCity',{GameInfo:new(city_info)})) or nil
      local oArmy = army_info and debug_gamestate:add(GameObject:new('gsArmy',{GameInfo:new(army_info)})) or nil

    end
  end
end

function Loader:debugGenerateSpaceMap (debug_gamestate)

  --Space Map
  local space_hexes = {
    {
      map = 'Space',
      address = 'Space_Earth_Planet',
      terrain_sprite = "TILE_PLANET_1",
      neighbors = {
        'Space_Earth_LowPrograde',
        'Space_Earth_LowRetrograde'
        },
      worldspace_coord = {0,0}
    },
    {
      map = 'Space',
      address = 'Space_Earth_LowPrograde',
      terrain_sprite = "TILE_SPACE_1",
      neighbors = {
        'Space_Earth_Planet',
        'Space_Luna_LowRetrograde'
      },
      worldspace_coord = {100,0}
    },
    {
      map = 'Space',
      address = 'Space_Earth_LowRetrograde',
      terrain_sprite = "TILE_SPACE_1",
      neighbors = {
        'Space_Earth_Planet',
      },
      worldspace_coord = {-100,0}
    },
    {
      map = 'Space',
      address = 'Space_Luna_LowRetrograde',
      terrain_sprite = "TILE_SPACE_1",
      neighbors = {
        'Space_Earth_LowPrograde',
        'Space_Luna_'
      },
      worldspace_coord = {200,0}
    },
    {
      map = 'Space',
      address = 'Space_Earth_LowPrograde',
      terrain_sprite = "TILE_PLANET_2",
      neighbors = {
        'Space_Luna_LowRetrograde'
      },
      worldspace_coord = {300,0}
    }
  }
  for i, v in ipairs(space_hexes) do
    debug_gamestate:add(GameObject:new('gsHex',{GameInfo:new(v)}))
  end
end

function Loader:debugGenerateMap ( save_name )
  --[[ Generate the Game State ]]--

  local debug_gamestate = Registry:new()--TODO: make this with a Registry:new();

  self:debugGenerateEarthMap(debug_gamestate)
  self:debugGenerateSpaceMap(debug_gamestate)

  self:saveGame(save_name, debug_gamestate)
end

function Loader:debugLoad ()

  --[[ Load Assets & Play some music because why not ]]--
  local Assets = self.loadContext.Assets

  local music = Assets:getAsset("MUSIC_FLOATING_CITIES")
  music:setLooping(true)
  music:setVolume(BG_MUSIC_VOL)
  music:play()

  --[[ Generate the Game State ]]--

  local debug_gamestate = self.loadContext.Registry--TODO: make this with a Registry:new();
  self:debugGenerateMap('default')
  self:loadGame('default',debug_gamestate)

  --[[Instantiate Tilemap View ]]--

  local EarthSceneGraph = IndexTree:new();
  local Earth_Tiles = {}
  local Earth_Cities = {}
  local Earth_Units = {}

  local SpaceSceneGraph = IndexTree:new();
  local Space_Tiles = {}
  local Space_Cities = {}
  local Space_Units = {}

  local Earth_Map = IndexMap:new()
  local Space_Map = IndexMap:new()
  Earth_Map:load(debug_gamestate,'Earth');
  Space_Map:load(debug_gamestate,'Space');

  local desiredMap = "Space"
  for key, obj in pairs(debug_gamestate.registry) do
    local tgt = obj:getComponent("GameInfo")
    if obj.description == 'gsHex' then
      if tgt.map == 'Earth' then
        table.insert(Earth_Tiles, TileMapViewIcon:new(debug_gamestate,EarthSceneGraph,Earth_Map,key))
      elseif tgt.map == 'Space' then
        table.insert(Space_Tiles, TileMapViewIcon:new(debug_gamestate,SpaceSceneGraph,Space_Map,key))
      end
    elseif obj.description == 'gsCity' then
      if tgt.map == 'Earth' then
        table.insert(Earth_Cities, CityMapViewIcon:new(debug_gamestate,EarthSceneGraph,Earth_Map,key))
      elseif tgt.map == 'Space' then
        table.insert(Space_Cities, CityMapViewIcon:new(debug_gamestate,SpaceSceneGraph,Space_Map,key))
      end
    elseif obj.description == 'gsArmy' then
      if tgt.map == 'Earth' then
        table.insert(Earth_Units, ArmyMapViewIcon:new(debug_gamestate,EarthSceneGraph,Earth_Map,key))
      elseif tgt.map == 'Space' then
        table.insert(Space_Units, ArmyMapViewIcon:new(debug_gamestate,SpaceSceneGraph,Space_Map,key))
      end
    end
  end

  local Earth_View = MapView:new(debug_gamestate, EarthSceneGraph, Earth_Tiles, Earth_Cities, Earth_Units)
  local Space_View = MapView:new(debug_gamestate, SpaceSceneGraph, Space_Tiles, Space_Cities, Space_Units)

  return EarthSceneGraph, SpaceSceneGraph
end

function Loader:saveGame ( name, gamestateRegistry)
  local serialized_gamestate = {}
  for i, obj in gamestateRegistry:getGameObjects("GameInfo") do
    table.insert(serialized_gamestate, obj:getComponent("GameInfo"):serialize())
  end
  love.filesystem.write((name .. '.sav'), Tserial.pack(serialized_gamestate))
end

function Loader:loadGame( name, registry)
  local contents, size = love.filesystem.read((name .. '.sav'))
  local raw_save = Tserial.unpack(contents)
  for i, v in pairs(raw_save) do
    local obj = GameInfo:reify(v)
    registry:add(obj)
  end
end

return Loader