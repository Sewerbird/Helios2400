--MapView.lua
local class = require 'lib/30log'
local statemachine = require('lib/statemachine')

local Interfaceable = require 'src/component/Interfaceable'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local MainMenuView = require 'src/ui/MainMenuView'
local QuickCommandPanelView = require 'src/ui/QuickCommandPanelView'
local ConfirmationDialogBoxView = require 'src/ui/ConfirmationDialogBoxView'
local TurnStartView = require 'src/ui/TurnStartView'
local CityInspectorView = require 'src/ui/CityInspectorView'
local ArmyInspectorView = require 'src/ui/ArmyInspectorView'
local ArmyMapViewIcon = require 'src/ui/ArmyMapViewIcon'

local MapView = class("MapView", {

})

function MapView:init( registry, scenegraph, map, tiles, cities, units )

  self.registry = registry
  self.scenegraph = scenegraph
  self.map = map

  local Map_Layer = registry:add(GameObject:new('Map Layer', {
    Transform:new()
    }))
  local Tile_Layer = registry:add(GameObject:new('Tile_Layer',{}))
  local City_Layer = registry:add(GameObject:new('City_Layer',{}))
  local Unit_Layer = registry:add(GameObject:new('Unit_Layer',{}))
  local UI_Layer = registry:add(GameObject:new('UI_Layer',{}))
  local Turn_Start_View = TurnStartView:new(registry, scenegraph)
  local Main_Menu_View = MainMenuView:new(registry, scenegraph)
  local Quick_Command_Panel_View = QuickCommandPanelView:new(registry, scenegraph)
  local Confirmation_Dialog_Box_View = ConfirmationDialogBoxView:new(registry, scenegraph)
  local City_Inspector_View = CityInspectorView:new(registry, scenegraph)
  local Army_Inspector_View = ArmyInspectorView:new(registry, scenegraph)

  local bg_click_interceptor = TouchDelegate:new()
  bg_click_interceptor:setHandler('onTouch',function(this)
      return true
  end)

  local Inspector = registry:add(GameObject:new('Inspector',{
      Transform:new(0,640),
      Renderable:new(
        Polygon:new({w=1200, h=160}),
        nil,
        {50,100,100,125},
        "Inspector Panel (has some commands, cursor information, minimap, etc). Press Escape to bring up the Main Menu"),
      Interfaceable:new(
        Polygon:new({w=1200, h=160}),
        bg_click_interceptor)
    }))
  local Inspector_Commands_Anchor = registry:add(GameObject:new('Inspectory_Commands_Anchor',{
      Transform:new(0,0)
    }))
  local Inspector_City_Anchor = registry:add(GameObject:new('Inspectory_City_Anchor',{
      Transform:new(125,0)
    }))
  local Inspector_Army_Anchor = registry:add(GameObject:new('Inspectory_Army_Anchor',{
      Transform:new(230+125,0)
    }))

  local Map_View_Touch_Delegate = TouchDelegate:new()
  Map_View_Touch_Delegate:setHandler('onDrag', function(this, x,y,dx,dy)
    if not Main_Menu_View.is_attached and registry:get(Map_Layer):hasComponent('Transform') then
      local t = registry:get(Map_Layer):getComponent('Transform')
      t:translateWithBounds(dx,dy,nil,{-74 * 3.5,0}) -- temp fix, 3.5 needs to be 1.5
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
  scenegraph:attachAll({Tile_Layer,City_Layer,Unit_Layer}, Map_Layer)
  scenegraph:attachAll({Inspector},UI_Layer)
  scenegraph:attachAll({Inspector_Commands_Anchor,Inspector_Army_Anchor,Inspector_City_Anchor},Inspector)
  self.scenegraph:attach(Quick_Command_Panel_View.root,Inspector_Commands_Anchor)

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

  registry:subscribe("selectCity", function(this, msg)
    if msg.icon_type == 'city' then
      print('Show city inspector for ' .. inspect(msg.address.address))
      City_Inspector_View:hide()
      City_Inspector_View:show(Inspector_City_Anchor,msg)
    end
  end)

  registry:subscribe("selectArmy", function(this, msg)
    if msg.icon_type == 'army' then
      --print('Show army inspector for ' .. inspect(msg.address.address))
      --Army_Inspector_View:hide()
      --Army_Inspector_View:show(Inspector_Army_Anchor,msg)
    end
  end)

  registry:subscribe("placeArmy", function(this, msg)
    if msg.map == self.map then
      print("Placing army on " .. self.map .. ': ' .. inspect(msg) .. ' -> ' .. Unit_Layer)
      self.scenegraph:attach(ArmyMapViewIcon:new(self.registry,self.scenegraph,msg.unit).root, Unit_Layer)
    end
  end)

  registry:subscribe(Quick_Command_Panel_View.root .. ":startTurnRequest", function(this, msg)
    Turn_Start_View:show(UI_Layer, self.registry:findComponent("GameInfo",{gs_type="player", is_current=true}))
  end)

  registry:subscribe(Quick_Command_Panel_View.root .. ":endTurnRequest", function(this, msg)
    if self.is_frozen then return end

    self.is_frozen = true

    local unsubConfirm = function() print('oops') end
    local unsubCancel = function() print('oops') end

    Confirmation_Dialog_Box_View:show(UI_Layer,"Whoa hey! You sure you want to end your turn?")

    unsubConfirm = self.registry:subscribe("confirm",function(this, msg)
      if not self.is_frozen then return end
      self.registry:publish("triggerEndTurn")
      self.registry:publish(Quick_Command_Panel_View.root .. ":startTurnRequest")
      unsubCancel()
      unsubConfirm()
      self.is_frozen = false
    end)
    
    unsubCancel = self.registry:subscribe("cancel",function(this,msg)
      if not self.is_frozen then return end
      unsubCancel()
      unsubConfirm()
      self.is_frozen = false
    end)
  end)

end

return MapView