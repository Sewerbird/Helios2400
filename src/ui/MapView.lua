--MapView.lua
local class = require 'lib/30log'
local Interfaceable = require 'src/component/Interfaceable'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local MainMenuView = require 'src/ui/MainMenuView'

local MapView = class("MapView", {

})

function MapView:init( registry, scenegraph, tiles, cities, units )

  local Map_Layer = registry:add(GameObject:new('Map Layer', {
    Transform:new()
    }))
  local Tile_Layer = registry:add(GameObject:new('Tile_Layer',{}))
  local City_Layer = registry:add(GameObject:new('City_Layer',{}))
  local Unit_Layer = registry:add(GameObject:new('Unit_Layer',{}))
  local UI_Layer = registry:add(GameObject:new('UI_Layer',{}))
  local Main_Menu_View = MainMenuView:new(registry, scenegraph)
  local Map_View_Touch_Delegate = TouchDelegate:new()
  local Inspector = registry:add(GameObject:new('Inspector',{
    Transform:new(0,675),
    Renderable:new(
      Polygon:new({w=1200, h=125}),
      nil,
      {50,100,100,125},
      "Inspector Panel (has some commands, cursor information, minimap, etc). Press Escape to bring up the Main Menu")
    }))

  Map_View_Touch_Delegate:setHandler('onDrag', function(this, x,y,dx,dy)
    if not Main_Menu_View.is_attached and registry:get(Map_Layer):hasComponent('Transform') then
      local t = registry:get(Map_Layer):getComponent('Transform')
      t:translate(dx,dy)
    end
  end)
  Map_View_Touch_Delegate:setHandler('onKeypress', function(this, btn)
    print('key pressed on map view: ' .. btn .. ' while showing_main_menu == ' .. tostring(Main_Menu_View.is_attached))
    if btn == 'escape' then
      if Main_Menu_View.is_attached then
        Main_Menu_View:hide()
      else
        Main_Menu_View:show(UI_Layer)
      end
    end
  end)
  local Map_View = registry:add(GameObject:new('Map_View',{
    Transform:new(0,0),
    Interfaceable:new(
      Polygon:new({w=1200, h=800}),
      Map_View_Touch_Delegate)
    }))

  scenegraph:attach(Map_View)
  scenegraph:attachAll({Map_Layer,UI_Layer}, Map_View)
  scenegraph:attach(Inspector,UI_Layer)
  scenegraph:attachAll({Tile_Layer,City_Layer,Unit_Layer}, Map_Layer)
  for i, tile in ipairs(tiles) do
    scenegraph:attach(tile.root, Tile_Layer)
  end
  for i, city in ipairs(cities) do
    scenegraph:attach(city.root, City_Layer)
  end
  for i, unit in ipairs(units) do
    scenegraph:attach(unit.root, Unit_Layer)
  end

  scenegraph:setRoot(Map_View)

end

return MapView