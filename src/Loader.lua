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

function Loader:debugGenerateEarthMap (debug_gamestate, assets)
  local city_names = {'New Moroni', 'Tiangong', 'Elonia', 'Neokyoto', 'Al Kicab', 'Choaswell', 'Atraapool', 'Efrimirie', 'Droawona'}
  local joffset = 0
  local num_rows = 12
  local num_cols = 24
  local players = debug_gamestate:getGameObjects("GameInfo")

  for i = 1 , num_cols do --x
    for j = 1 , num_rows do
      if (i - 1) % 2 == 0 then joffset = 0 else joffset = 37 end
      local isCapitol = (i == 5) and (j == 5)
      local ioffset = (i-1) * -21
      local hex = (j==1 or j==num_rows or math.random()>0.5) and "TILE_ARCTIC_1" or ((math.random() < 0.7 or isCapitol) and "TILE_GRASS_1" or "TILE_WATER_1")
      local army = (math.random() < 0.05) and "SPEC_UNIT_INFANTRY_1" or (math.random() < 0.5 and "SPEC_UNIT_ARTILLERY_1" or "SPEC_UNIT_MECH_1")
      local player = math.random(1,#players)
      local playerInfo = players[player]:getComponent('GameInfo')

      local hex_info = {
        gs_type = "tile",
        map = 'Earth',
        address = 'Earth' .. HexCoord:new(i,j):toString(),
        terrain_sprite = hex,
        neighbors = {},
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset},
        terrain_info = {
          type = (hex == "TILE_WATER_1") and "water" or "land",
          land = (hex == "TILE_WATER_1") and 0 or 1,
          sea = (hex ~= "TILE_WATER_1") and 0 or 1,
          aero = 1,
          hover = 1,
          space = 0,
          reentry = 1,
          toxic = false,
          vacuum = false,
          shielded = false,
        }
      }


      if self.inBounds(i,j-1,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i,j-1):toString()) end
      if self.inBounds(i,j+1,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i,j+1):toString()) end
      if (i % 2 == 0) and self.inBounds(i-1,j+1,num_cols,num_rows) then 
        table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i-1,j+1):toString())
        end
      if (i % 2 == 1) and self.inBounds(i-1,j-1,num_cols,num_rows) then 
        table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i-1,j-1):toString())
      end
      if (i % 2 == 0) and self.inBounds(i+1,j+1,num_cols,num_rows) then 
        table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i+1,j+1):toString())
        end
      if (i % 2 == 1) and self.inBounds(i+1,j-1,num_cols,num_rows) then 
        table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i+1,j-1):toString())
      end
      if self.inBounds(i-1,j,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i-1,j):toString()) end
      if self.inBounds(i+1,j,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(i+1,j):toString()) end
          
      if i == 1 then 
        if self.inBounds(i,j,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(num_cols,j):toString()) end
        if self.inBounds(i,j-1,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(num_cols,j-1):toString()) end
      elseif i == num_cols then
        if self.inBounds(i,j,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(1,j):toString()) end
        if self.inBounds(i,j+1,num_cols,num_rows) then table.insert(hex_info.neighbors,'Earth' .. HexCoord:new(1,j+1):toString()) end
      end
      local city_info = (isCapitol or (hex == "TILE_GRASS_1" and math.random() < 0.05)) and {
        gs_type = "city",
        owner = playerInfo.player_name,
        is_planetary_capitol = isCapitol,
        turns_owned = {[playerInfo.player_name] = 0},
        city_name = isCapitol and 'NORTH POLE' or city_names[math.floor(math.random()*#city_names)+1],
        map = 'Earth',
        address = hex_info.address,
        icon_sprite = "CITY_1",
        worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset},
        build_queue = {},
        base_build_point_rate = 10,
        base_income_rate = 10
      } or nil
      local army_info = nil
      if hex == "TILE_GRASS_1" and math.random() < 0.20 then
        army_info = assets:getSpec(army)
        army_info.gs_type = "army"
        army_info.map = 'Earth'
        army_info.army_name = playerInfo.player_name
        army_info.address = hex_info.address
        army_info.worldspace_coord = {(i-1) * 84 + ioffset, (j-1) * 73 + joffset}
        army_info.owner = playerInfo.player_name
        army_info.turns_owned = {[playerInfo.player_name] = 1}
        army_info.curr_hp = army_info.max_hp
        army_info.curr_move = army_info.max_move
      end

      local oHex = debug_gamestate:add(GameObject:new('gsHex',{GameInfo:new(hex_info)}))
      local oCity = city_info and debug_gamestate:add(GameObject:new('gsCity',{GameInfo:new(city_info)})) or nil
      local oArmy = army_info and debug_gamestate:add(GameObject:new('gsArmy',{GameInfo:new(army_info)})) or nil

    end
  end
end

function Loader.inBounds(x, y, xBound, yBound)
  return x > 0 and y > 0 and x <= xBound and y <= yBound
end

function Loader:debugGenerateSpaceMap (debug_gamestate, assets)

  --Space Map
  local space_hexes = {
    {
      gs_type = 'tile',
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
      gs_type = 'tile',
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
      gs_type = 'tile',
      map = 'Space',
      address = 'Space_Earth_LowRetrograde',
      terrain_sprite = "TILE_SPACE_1",
      neighbors = {
        'Space_Earth_Planet',
      },
      worldspace_coord = {-100,0}
    },
    {
      gs_type = 'tile',
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
      gs_type = 'tile',
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

function Loader:debugGenerateMap ( save_name, assets)
  --[[ Generate the Game State ]]--

  local debug_gamestate = Registry:new()

  debug_gamestate:add(GameObject:new('gsPlayer',{
    GameInfo:new({
      gs_type = 'player',
      is_current = true,
      is_alive = true,
      player_name = 'Eastasia',
      cash_balance = 10,
      highlight_color = {20,200,200},
      midtone_color = {20,130,150},
      shadow_color = {5,80,100}
    })
  }))
  debug_gamestate:add(GameObject:new('gsPlayer',{
    GameInfo:new({
      gs_type = 'player',
      is_current = false,
      is_alive = true,
      player_name = 'Oceania',
      cash_balance = 10,
      highlight_color = {80,150,230},
      midtone_color = {60,100,180},
      shadow_color = {30,50,120}
    })
  }))
  debug_gamestate:add(GameObject:new('gsPlayer',{
    GameInfo:new({
      gs_type = 'player',
      is_current = false,
      is_alive = true,
      player_name = 'Eurasia',
      cash_balance = 10,
      highlight_color = {220,100,100},
      midtone_color = {160,60,60},
      shadow_color = {120,30,30}
    })
  }))

  self:debugGenerateEarthMap(debug_gamestate, assets)
  self:debugGenerateSpaceMap(debug_gamestate, assets)

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
  self:debugGenerateMap('default', Assets)
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
        table.insert(Earth_Units, ArmyMapViewIcon:new(debug_gamestate,EarthSceneGraph,key))
      elseif tgt.map == 'Space' then
        table.insert(Space_Units, ArmyMapViewIcon:new(debug_gamestate,SpaceSceneGraph,key))
      end
    end
  end

  local Earth_View = MapView:new(debug_gamestate, EarthSceneGraph, 'Earth', Earth_Tiles, Earth_Cities, Earth_Units)
  local Space_View = MapView:new(debug_gamestate, SpaceSceneGraph, 'Space', Space_Tiles, Space_Cities, Space_Units)


  self.loadContext.Registry:setStructure('Earth', Earth_Map)
  self.loadContext.Registry:setStructure('Space', Space_Map)

  return EarthSceneGraph, SpaceSceneGraph
end

function Loader:saveGame ( name, gamestateRegistry)
  local serialized_gamestate = {}
  for i, obj in pairs(gamestateRegistry:getGameObjects("GameInfo")) do
    table.insert(serialized_gamestate, obj:getComponent("GameInfo"):serialize())
  end
  love.filesystem.write((name .. '.sav'), Tserial.pack(serialized_gamestate))
end

function Loader:loadGame( name, registry)
  local contents, size = love.filesystem.read((name .. '.sav'))
  local raw_save = Tserial.unpack(contents)
  for i, v in pairs(raw_save) do
    GameInfo:reify(registry, v)
  end
end

return Loader