--armyMapViewIcon.lua
local class = require 'lib/30log'
local Renderable = require 'src/component/Renderable'
local Addressable = require 'src/component/Addressable'
local Placeable = require 'src/component/Placeable'
local Moveable = require 'src/component/Moveable'
local Interfaceable = require 'src/component/Interfaceable'
local Transform = require 'src/component/Transform'
local Stateful = require 'src/component/Stateful'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local ArmyMapViewIcon = class("ArmyMapViewIcon",{
	root = nil
})

function ArmyMapViewIcon:init( registry, scenegraph, map, gamestate )
      local gameinfo = registry:getComponent(gamestate, "GameInfo")
      local playerinfo = registry:findComponent("GameInfo", {player_name = gameinfo.owner})
      local Unit_Touch_Delegate = TouchDelegate:new()
      Unit_Touch_Delegate:setHandler('onTouch', function(this, x, y)
        if this.component.gob:hasComponent('Placeable') then
          registry:publish("select",{uid = this.component.gob.uid})
          print('Clicked on a unit (' .. this.component.gob.uid .. ')! Is situated at address:' .. map:summarizeAddress(this.component:getSiblingComponent('Placeable').address))
          return true
        end
      end)
      debug_army = registry:add(GameObject:new('Army', {
        Transform:new(
          gameinfo.worldspace_coord[1], 
          gameinfo.worldspace_coord[2]
          ):bindTo(gamestate .. "_GameInfo", function (this, cmp, msg)
            local new_xy = registry:getComponent(msg.destination_info, "GameInfo").worldspace_coord
            cmp.x = new_xy[1]
            cmp.y = new_xy[2]
        end),
        Interfaceable:new(
          Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73, 0,37}),
          Unit_Touch_Delegate),
        Stateful:new(gamestate),
        Placeable:new(gameinfo.address),
        Moveable:new()
      }))
      debug_army_bg = registry:add(GameObject:new('Army_BG', {
        Transform:new((84-50)/2, (73-50)/2),
        Renderable:new(
          Polygon:new({ w = 50, h = 50}),
          nil,
          playerinfo.midtone_color),
        Stateful:new(gamestate)
      }))
      debug_army_bg_shadow = registry:add(GameObject:new('Army_BGb', {
        Transform:new(0, 0),
        Renderable:new(
          Polygon:new({0,0 , 3,3 , 3,45 , 45,45 , 50,50 , 0,50}),
          nil,
          playerinfo.shadow_color),
        Stateful:new(gamestate)
      }))
      debug_army_sprite = registry:add(GameObject:new('Troop', {
        Transform:new(3,5),
        Renderable:new(
          Polygon:new({ w = 50, h = 50 }),
          Global.Assets:getAsset(gameinfo.icon_sprite)),
        Stateful:new(gamestate)
      }))
      debug_army_name = registry:add(GameObject:new('Name', {
        Transform:new(-3,0),
        Renderable:new(
          nil,
          nil,
          nil,
          gameinfo.army_name),
        Stateful:new(gamestate)
      }))
      debug_army_health = registry:add(GameObject:new('HealthBar', {
        Transform:new(0,45),
        Renderable:new(
          Polygon:new({ w = 50 * (gameinfo.curr_hp / gameinfo.max_hp), h=5}),
          nil,
          playerinfo.highlight_color):bindTo("tick", function (this, cmp, msg) 
            cmp.polygon = Polygon:new({w = 50 * msg.percent, h = 5})
        end),
        Stateful:new(gamestate)
      }))
      --[[
      debug_army_timer = registry:add(GameObject:new('Timer', {
        Transform:new(0,15),
        Renderable:new(
          nil,
          nil,
          nil,
          gameinfo.address
          ):bindTo(gamestate .. "_GameInfo", function(this, cmp, msg) 
          cmp.text = registry:getComponent(gamestate,"GameInfo").address
        end),
        Stateful:new(gamestate)
      }))]]
      scenegraph:attach(debug_army,nil)
      scenegraph:attach(debug_army_bg, debug_army)
      scenegraph:attachAll({debug_army_bg_shadow, debug_army_sprite, debug_army_name, debug_army_health--[[, debug_army_timer]]}, debug_army_bg)

   	self.root = debug_army
end

return ArmyMapViewIcon