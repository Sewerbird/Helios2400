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
local MutatorBus = require 'src/mutate/MutatorBus'
local Viewer = require 'src/ui/Viewer'
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
local DebugGameGenerator = require 'src/DebugGameGenerator'

local Loader = class("Loader", {
  loadContext = nil
	
})

function Loader:init(context)
  self.loadContext = context
end

function Loader:debugLoad (save)

  --[[ Load Assets & Play some music because why not ]]--
  local Assets = self.loadContext.Assets

  local music = Assets:getAsset("MUSIC_FLOATING_CITIES")
  music:setLooping(true)
  music:setVolume(BG_MUSIC_VOL)
  music:play()

  --[[ Generate the Game State ]]--

  self:unloadGame(Global.Registry)
  self.loadContext.Registry = Registry:new();
  local debug_gamestate = self.loadContext.Registry--TODO: make this with a Registry:new();

  if save then
    self:loadGame(save, debug_gamestate)
  else
    local scn_gen = DebugGameGenerator:new()
    self:saveGame('default',scn_gen:debugGenerateMap(Assets))
    self:loadGame('default',debug_gamestate)
  end

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


  Global.MutatorBus = MutatorBus:new(Global.Registry)
  Global.Viewer = Viewer:new(Global.Registry, {EarthSceneGraph,SpaceSceneGraph})

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

function Loader:unloadGame( registry )
  for i, v in pairs(registry) do
    registry[v] = nil
  end
end

return Loader