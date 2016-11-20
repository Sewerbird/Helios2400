--MapView.lua
local Interfaceable = require 'src/component/Interfaceable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'

local MapView = {}

MapView.new = function(self, registry, scenegraph, map, tiles, cities, units)

  local Map_Layer = registry:add(GameObject:new('Map Layer', {
    Transform:new(-60,10)
    }))
  local Map_View_Touch_Delegate = TouchDelegate:new();
  Map_View_Touch_Delegate:setHandler('onDrag', function(this, x,y,dx,dy)
    if registry:get(Map_Layer):hasComponent('Transform') then
      local t = registry:get(Map_Layer):getComponent('Transform')
      t:translate(dx,dy)
    end
  end)
  local Map_View = registry:add(GameObject:new('Map_View',{
    Transform:new(0,0),
    Interfaceable:new(
      Polygon:new({w=1200, h=800}),
      Map_View_Touch_Delegate)
    }))

  local Tile_Layer = registry:add(GameObject:new('Tile_Layer',{}))
  local City_Layer = registry:add(GameObject:new('City_Layer',{}))
  local Unit_Layer = registry:add(GameObject:new('Unit_Layer',{}))
  local UI_Layer = registry:add(GameObject:new('UI_Layer',{}))

  scenegraph:attach(Map_View)
  scenegraph:attachAll({Map_Layer,UI_Layer}, Map_View)
  scenegraph:attachAll({Tile_Layer,City_Layer,Unit_Layer,UI_Layer}, Map_Layer)
  scenegraph:attachAll(tiles, Tile_Layer)
  scenegraph:attachAll(cities, City_Layer)
  scenegraph:attachAll(units, Unit_Layer)

  return me_view --, Tile_Layer, City_Layer, Unit_Layer, UI_Layer
end

return MapView