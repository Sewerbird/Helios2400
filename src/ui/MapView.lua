--MapView.lua
local class = require 'lib/30log'
local Interfaceable = require 'src/component/Interfaceable'
local Renderable = require 'src/component/Renderable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local MainMenuView = require 'src/ui/MainMenuView'
local QuickCommandPanelView = require 'src/ui/QuickCommandPanelView'
local ConfirmationDialogBoxView = require 'src/ui/ConfirmationDialogBoxView'

local MapView = class("MapView", {

})

function MapView:init( registry, scenegraph, tiles, cities, units )

  self.registry = registry
  self.scenegraph = scenegraph

  local Map_Layer = registry:add(GameObject:new('Map Layer', {
    Transform:new()
    }))
  local Tile_Layer = registry:add(GameObject:new('Tile_Layer',{}))
  local City_Layer = registry:add(GameObject:new('City_Layer',{}))
  local Unit_Layer = registry:add(GameObject:new('Unit_Layer',{}))
  local UI_Layer = registry:add(GameObject:new('UI_Layer',{}))
  local Main_Menu_View = MainMenuView:new(registry, scenegraph)
  local Quick_Command_Panel_View = QuickCommandPanelView:new(registry, scenegraph)
  local Map_View_Touch_Delegate = TouchDelegate:new()
  local Confirmation_Dialog_Box_View = ConfirmationDialogBoxView:new(registry, scenegraph)
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
  scenegraph:attachAll({Inspector},UI_Layer)
  scenegraph:attachAll({Quick_Command_Panel_View.root},Inspector)
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


  registry:subscribe(Quick_Command_Panel_View.root .. ":endTurnRequest", function(this, msg)
    if self.is_frozen then return end

    self.is_frozen = true

    local unsubConfirm = function() print('oops') end
    local unsubCancel = function() print('oops') end

    Confirmation_Dialog_Box_View:show(UI_Layer,"Whoa hey! You sure you want to end your turn?")

    unsubConfirm = self.registry:subscribe("confirm",function(this, msg)
      if not self.is_frozen then return end
      self.registry:publish("triggerEndTurn")
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