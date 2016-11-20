--armyMapViewIcon.lua
local Renderable = require 'src/component/Renderable'
local Addressable = require 'src/component/Addressable'
local Placeable = require 'src/component/Placeable'
local Moveable = require 'src/component/Moveable'
local Interfaceable = require 'src/component/Interfaceable'
local Transform = require 'src/component/Transform'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local ArmyMapViewIcon = {}

ArmyMapViewIcon.new = function(self, registry, scenegraph, map, gameinfo)
      local Unit_Touch_Delegate = TouchDelegate:new()
      Unit_Touch_Delegate:setHandler('onTouch', function(this, x, y)
        if this.component.gob:hasComponent('Placeable') then
          Global.PubSub:publish("select",{uid = this.component.gob.uid})
          print('Clicked on a unit (' .. this.component.gob.uid .. ')! Is situated at address:' .. map:summarizeAddress(this.component:getSiblingComponent('Placeable').address))
          return true
        end
      end)
      debug_army = registry:add(GameObject:new('Army', {
        Transform:new(gameinfo.worldspace_coord[1],gameinfo.worldspace_coord[2]),
        Interfaceable:new(
          Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73, 0,37}),
          Unit_Touch_Delegate),
        Placeable:new(gameinfo.address),
        Moveable:new()
      }))
      debug_army_bg = registry:add(GameObject:new('Army_BG', {
        Transform:new((84-50)/2, (73-50)/2),
        Renderable:new(
          Polygon:new({ w = 50, h = 50}),
          nil,
          gameinfo.team_color)
      }))
      debug_army_sprite = registry:add(GameObject:new('Troop', {
        Transform:new(3,5),
        Renderable:new(
          Polygon:new({ w = 50, h = 50 }),
          Global.Assets:getAsset(gameinfo.icon_sprite)
        )
      }))
      debug_army_name = registry:add(GameObject:new('Name', {
        Transform:new(-3,0),
        Renderable:new(
          nil,
          nil,
          nil,
          gameinfo.army_name)
      }))
      debug_army_health = registry:add(GameObject:new('HealthBar', {
        Transform:new(0,45),
        Renderable:new(
          Polygon:new({ w = 50 * (gameinfo.curr_hp / gameinfo.max_hp), h=5}),
          nil,
          {100,200,100}):bindstate('polygon', nil, 'hurt', function(this, cmp, msg) 
            cmp.polygon = Polygon:new({w = 50 * (msg.percent), h=5}) 
          end)
      }))
      debug_army_timer = registry:add(GameObject:new('Timer', {
        Transform:new(0,15),
        Renderable:new(
          nil,
          nil,
          nil,
          "0:00"):bindstate('text', nil, 'hurt', function(this, cmp, msg) 
            cmp.text = math.floor(100 * msg.percent) .. "%"
          end)
      }))
      scenegraph:attach(debug_army,nil)
      scenegraph:attach(debug_army_bg, debug_army)
      scenegraph:attachAll({debug_army_sprite, debug_army_name, debug_army_health, debug_army_timer}, debug_army_bg)

	return debug_army
end

return ArmyMapViewIcon