local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local ProduceArmyMutator = require 'src/mutate/mutator/ProduceArmyMutator'

local CityInspectorSummaryCardView = class("CityInspectorSummaryCardView", {
    root = nil,
    registry = nil,
    scenegraph = nil
})

function CityInspectorSummaryCardView:init (registry, scenegraph)
    self.root = registry:add(GameObject:new("civScard", {
        Transform:new(0,0)
    }))

    self.registry = registry
    self.scenegraph = scenegraph
    
    --[[Handlers]]--
    self.build_button_handler = TouchDelegate:new()

    --[[Components]]--

    local bg_rect = registry:add(GameObject:new("civScard_bg_rect",{
        Transform:new(5,5),
        Renderable:new(
            Polygon:new({w = 230, h = 160}),
            nil,
            {250,120,120} --TODO: player highlight color
            )
        }))

    local shield = registry:add(GameObject:new("civScard_shield",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({0,0 , 10,10 , 40,10 , 60,30 , 180,30 , 200,10 , 230,10 , 230,150 , 10,150 , 10,10.1 , 0,0.1 , 0,160 , 240,160 , 240,0}),
            nil,
            {120,30,30}--TODO: player shade color
            )
        }))

    local title_rect = registry:add(GameObject:new("civScard_title_rect",{
        Transform:new(45,5),
        Renderable:new(
            Polygon:new({0,0 , 150,0 , 132,18 , 18,18}),
            nil,
            {200,80,80},--TOOD: player midtone color
            "CITY NAME HERE" --TODO: city name
            )
        }))

    local info_text = registry:add(GameObject:new("civScard_info_rect",{
        Transform:new(10,30),
        Renderable:new(
            Polygon:new({w = 220, h = 50}),
            nil,
            {200,200,200,0},
            "CITY OWNER HERE (3 turns)\nFACTION: Mormons"
            )
        }))

    local build_summary = registry:add(GameObject:new("civScard_build_summary",{
        Transform:new(10,85),
        Renderable:new(
            Polygon:new({w = 10, h = 10}),
            nil,
            {0,0,0,0},
            "bs")
    }))

    local being_built_icon = registry:add(GameObject:new("civScard_being_built_icon",{
        Transform:new(-12+25,-15+25),
        Renderable:new(
            Polygon:new({w = 25, h = 30}),
            Global.Assets:getAsset("UNIT_MECH_1"),
            {200,200,0}),
        Interfaceable:new(
            Polygon:new({w = 25, h = 30}),
            self.build_button_handler)
        }))

    local build_thermometer_text = registry:add(GameObject:new("civScard_therm_text",{
        Transform:new(50,0),
        Renderable:new(
            Polygon:new({w = 160, h = 30}),
            nil,
            {255,255,255,100},
            "'Mad Cat' Mech Squad\n(3 turns left)"
            )
        }))
    local build_thermometer_bg = registry:add(GameObject:new("civScard_therm_back",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({0,0 , 50,0 , 50,15+15 , 200+10,15+15 , 200+10,35+15 , 50,35+15 , 50,50 , 0,50}),
            nil,
            {120,30,30})
        }))

    local build_thermometer_wrap = registry:add(GameObject:new("civScard_therm_wrap",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({5,5 , 45,5 , 45,20+15 , 195+10,20+15 , 195+10,30+15 , 45,30+15 , 45,45 , 5,45}),
            nil,
            {220,50,50})
        }))
    
    local build_thermometer_progress = registry:add(GameObject:new("civScard_therm_top",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({5,5 , 45,5 , 45,20+15 , 195+10,20+15 , 195+10,30+15 , 35,30+15 , 5,45}),
            nil,
            {250,80,80})
        }))

    scenegraph:attach(self.root,nil)
    scenegraph:attachAll({bg_rect, info_text, shield},self.root)
    scenegraph:attach(build_summary, bg_rect)
    scenegraph:attachAll({build_thermometer_bg, build_thermometer_wrap, build_thermometer_progress, being_built_icon, build_thermometer_text}, build_summary)
    scenegraph:attach(title_rect, shield)
    scenegraph:detach(self.root,nil)

    self.bg_rect = bg_rect
    self.shield = shield
    self.title_rect = title_rect
    self.build_summary = build_summary
    self.build_thermometer_progress = build_thermometer_progress
    self.build_thermometer_wrap = build_thermometer_wrap
    self.build_thermometer_bg = build_thermometer_bg
    self.build_thermometer_text = build_thermometer_text
    self.info_text = info_text
end

function CityInspectorSummaryCardView:show( curr_player, city_player, city )
    self.registry:getComponent(self.bg_rect,"Renderable").backgroundcolor = curr_player.midtone_color
    self.registry:getComponent(self.shield,"Renderable").backgroundcolor = curr_player.shadow_color
    local title = self.registry:getComponent(self.title_rect,"Renderable")
        title.backgroundcolor = city_player.highlight_color
        title.text = city.city_name
    self.registry:getComponent(self.build_thermometer_bg,"Renderable").backgroundcolor = curr_player.shadow_color
    self.registry:getComponent(self.build_thermometer_wrap,"Renderable").backgroundcolor = city_player.midtone_color
    local build_progress = self.registry:getComponent(self.build_thermometer_progress,"Renderable")
        build_progress.backgroundcolor = city_player.highlight_color
        local progress_percent = math.random()
        local px_e = 45+(progress_percent*(200-45))
        build_progress.polygon = Polygon:new({5,5 , 45,5 , 45,20+15 , px_e,20+15 , px_e,30+15 , 35,30+15, 5,45})
    local info = self.registry:getComponent(self.info_text,"Renderable")
        info.text = "Controlled by ".. tostring(city.owner).." ".. tostring(city.turns_owned[city.owner]) .." turns"

    self.build_button_handler:setHandler('onTouch', function(this, x, y)
        if city then
            print('Button pressed: building unit at city named ' .. city.city_name)
            self.registry:publish("IMMEDIATE_MUTATE", ProduceArmyMutator:new("SPEC_UNIT_MECH_1",city.address))
        end
    end)
end

local CityInspectorView = class("CityInspectorView", {
	root = nil,
	is_attached = false,
	scenegraph = nil,
    cityInfo = nil
})

function CityInspectorView:init (registry, scenegraph)
	self.root = registry:add(GameObject:new("civ_root", {
		Transform:new(125,0)
	}))
	self.scenegraph = scenegraph
	self.registry = registry

    self.summary_card = CityInspectorSummaryCardView:new(registry, scenegraph)

	self.scenegraph:attach(self.root, nil)
    self.scenegraph:attach(self.summary_card.root, self.root)
	self.scenegraph:detach(self.root)

end

function CityInspectorView:show ( attachTo, city )
	if not self.is_attached then
        self.scenegraph:attach(self.root, attachTo)
		self.is_attached = true

        local cityInfo = self.registry:get(city.gamestate):getComponent("GameInfo")
        local currentPlayerInfo = self.registry:findComponent("GameInfo",{gs_type = "player", is_current = true})
        local cityPlayerInfo = self.registry:findComponent("GameInfo",{gs_type = "player", player_name = cityInfo.owner})
        self.summary_card:show( currentPlayerInfo, cityPlayerInfo, cityInfo )

        self.citySubscription = self.registry:subscribe(city.gamestate .. "_GameInfo", function(this,msg)
            local cityInfo = self.registry:get(city.gamestate):getComponent("GameInfo")
            local currentPlayerInfo = self.registry:findComponent("GameInfo",{gs_type = "player", is_current = true})
            local cityPlayerInfo = self.registry:findComponent("GameInfo",{gs_type = "player", player_name = cityInfo.owner})
            self.summary_card:show(currentPlayerInfo, cityPlayerInfo, cityInfo)
        end)
	end
end

function CityInspectorView:hide ()
	if self.is_attached then
		self.scenegraph:detach(self.root)
		self.is_attached = false
        self:citySubscription()
	end
end

return CityInspectorView