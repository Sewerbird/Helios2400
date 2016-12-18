--armyMapViewIcon.lua
local class = require 'lib/30log'
local Renderable = require 'src/component/Renderable'
local Addressable = require 'src/component/Addressable'
local Placeable = require 'src/component/Placeable'
local Moveable = require 'src/component/Moveable'
local Interfaceable = require 'src/component/Interfaceable'
local Transform = require 'src/component/Transform'
local Stateful = require 'src/component/Stateful'
local GameInfo = require 'src/component/GameInfo'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local GameObject = require 'src/GameObject'
local Polygon = require 'src/datatype/Polygon'
local Sprite = require 'src/datatype/Sprite'

local ArmyMapViewIcon = class("ArmyMapViewIcon",{
	root = nil
})

function ArmyMapViewIcon:init( registry, scenegraph, gamestate )
      local gameinfo = registry:getComponent(gamestate, "GameInfo")
      local playerinfo = registry:findComponent("GameInfo", {player_name = gameinfo.owner})
      local Unit_Touch_Delegate = TouchDelegate:new()
      Unit_Touch_Delegate:setHandler('onTouch', function(this, x, y)
        if this.component.gob:hasComponent('Placeable') then
					registry:publish("selectIcon",{uid = this.component.gob.uid, address = this.component:getSiblingComponent('Placeable'), gamestate = gamestate, icon_type = 'army'})
					registry:publish("selectArmy",{uid = this.component.gob.uid, address = this.component:getSiblingComponent('Placeable'), gamestate = gamestate, icon_type = 'army'})
					return true
        end
      end)
      debug_army = registry:add(GameObject:new('Army', {
        Transform:new(
          gameinfo.worldspace_coord[1], 
          gameinfo.worldspace_coord[2]
          ):bindTo(gamestate .. "_GameInfo", function (this, cmp, msg)
            local new_xy = msg.worldspace_coord
            cmp.x = new_xy[1]
            cmp.y = new_xy[2]
        end),
        Interfaceable:new(
          Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73, 0,37}),
          Unit_Touch_Delegate),
        Stateful:new(gamestate),
        Placeable:new(gameinfo.address):bindTo(gamestate .. "_GameInfo", function (this, cmp, msg)
          cmp.address = msg.address
        end),
        Moveable:new()
      }))
      debug_army_bg = registry:add(GameObject:new('Army_BG', {
        Transform:new((84-50)/2, (73-50)/2),
        Renderable:new(
          Polygon:new({ w = 50, h = 50}),
          nil,
          playerinfo.midtone_color
          ):bindTo(gamestate .. "_GameInfo", function (this, cmp, msg)
            local new_playerinfo = registry:findComponent("GameInfo", {player_name = msg.owner})
            if new_playerinfo then cmp.backgroundcolor = new_playerinfo.midtone_color end
        end),
        Stateful:new(gamestate)
      }))
      debug_army_bg_shadow = registry:add(GameObject:new('Army_BGb', {
        Transform:new(0, 0),
        Renderable:new(
          Polygon:new({0,0 , 3,3 , 3,45 , 45,45 , 50,50 , 0,50}),
          nil,
          playerinfo.shadow_color):bindTo(gamestate .. "_GameInfo", function (this, cmp, msg)
            local new_playerinfo = registry:findComponent("GameInfo", {player_name = msg.owner})
            if new_playerinfo then cmp.backgroundcolor = new_playerinfo.shadow_color end
        end),
        Stateful:new(gamestate)
      }))
      debug_army_sprite = registry:add(GameObject:new('Troop', {
        Transform:new(12,12),
        Renderable:new(
          Polygon:new({ w = 25, h = 30 }),
          Global.Assets:getAsset(gameinfo.icon_sprite)),
        Stateful:new(gamestate)
      }))
      debug_army_name = registry:add(GameObject:new('Name', {
        Transform:new(-3,0),
        Renderable:new(
          nil,
          nil,
          nil,
          gameinfo.army_name):bindTo(gamestate .. "_GameInfo", function (this, cmp, msg)
            cmp.text = msg.army_name
        end),
        Stateful:new(gamestate)
      }))
      debug_army_health = registry:add(GameObject:new('HealthBar', {
        Transform:new(0,45),
        Renderable:new(
          Polygon:new({ w = 50 * (gameinfo.curr_hp / gameinfo.max_hp), h=5}),
          nil,
          playerinfo.highlight_color):bindTo(gamestate .. "_GameInfo", function (this, cmp, msg)
            local new_playerinfo = registry:findComponent("GameInfo", {player_name = msg.owner})
            if new_playerinfo then 
              cmp.backgroundcolor = new_playerinfo.highlight_color 
              cmp.polygon = Polygon:new({w = 50 * (msg.curr_hp / msg.max_hp), h = 5})
            end
        end),
        Stateful:new(gamestate)
      }))
      debug_army_moves = registry:add(GameObject:new('MovePointsCounter', {
        Transform:new(0,33),
        Renderable:new(
          Polygon:new({ w = 12, h = 12 }),
          nil,
          {10,10,10},
          gameinfo.curr_move
          ):bindTo(gamestate .. "_GameInfo", function(this, cmp, msg) 
          cmp.text = registry:getComponent(gamestate,"GameInfo").curr_move
          if cmp.text <= 0 then
            cmp.text = ""
            cmp.polygon = Polygon:new({0,-33 , 50,-33 , 50,12 , 0,12})
            cmp.transform = Transform:new(0,0)
            cmp.backgroundcolor = {10,10,10,100}
          else 
            cmp.transform = Transform:new(0,33)
            cmp.text = "" .. cmp.text 
            cmp.polygon = Polygon:new( { w = 8 * #cmp.text, h = 12})
            cmp.backgroundcolor = {10,10,10}
          end
        end),
        Stateful:new(gamestate)
      }))
      scenegraph:attach(debug_army,nil)
      scenegraph:attach(debug_army_bg, debug_army)
      scenegraph:attachAll({debug_army_bg_shadow, debug_army_sprite, debug_army_name, debug_army_health, debug_army_moves}, debug_army_bg)

   	self.root = debug_army

    self.unsub = registry:subscribe(gamestate .. "_GameInfo", function(this, msg)
    	if msg.curr_hp <= 0 then
    		scenegraph:detach(self.root)
    	end
    end)
end

return ArmyMapViewIcon