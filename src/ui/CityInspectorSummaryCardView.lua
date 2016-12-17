local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local ProduceArmyMutator = require 'src/mutate/mutator/ProduceArmyMutator'

local CityInspectorBuildMenuCardView = require 'src/ui/CityInspectorBuildMenuCardView'

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
    self.halt_button_handler = TouchDelegate:new()

    --[[Components]]--

    self.bg_rect = registry:add(GameObject:new("civScard_bg_rect",{
        Transform:new(5,5),
        Renderable:new(
            Polygon:new({w = 230, h = 160}),
            nil,
            {120,120,120} --TODO: player highlight color
            )
        }))

    self.shield = registry:add(GameObject:new("civScard_shield",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({0,0 , 10,10 , 40,10 , 60,30 , 180,30 , 200,10 , 230,10 , 230,150 , 10,150 , 10,10.1 , 0,0.1 , 0,160 , 240,160 , 240,0}),
            nil,
            {30,30,30}--TODO: player shade color
            )
        }))

    self.title_rect = registry:add(GameObject:new("civScard_title_rect",{
        Transform:new(45,5),
        Renderable:new(
            Polygon:new({0,0 , 150,0 , 132,18 , 18,18}),
            nil,
            {80,80,80},--TOOD: player midtone color
            "CITY NAME HERE" --TODO: city name
            )
        }))

    self.info_text = registry:add(GameObject:new("civScard_info_rect",{
        Transform:new(10,30),
        Renderable:new(
            Polygon:new({w = 220, h = 50}),
            nil,
            {200,200,200,0},
            "CITY OWNER HERE (3 turns)\nFACTION: Mormons"
            )
        }))

    self.build_summary = registry:add(GameObject:new("civScard_build_summary",{
        Transform:new(10,85),
        Renderable:new(
            Polygon:new({w = 10, h = 10}),
            nil,
            {0,0,0,0},
            "bs")
    }))

    self.being_built_icon = registry:add(GameObject:new("civScard_being_built_icon",{
        Transform:new(-12+25,-15+25),
        Renderable:new(
            Polygon:new({w = 25, h = 30}),
            Global.Assets:getAsset("UNIT_UNKNOWN_1"),
            {200,200,0})
        }))

    self.build_button = registry:add(GameObject:new("civScard_build_btn",{
        Transform:new(50,15),
        Renderable:new(
            Polygon:new({w = 80, h = 15}),
            nil,
            {20,20,20,200},
            "Build"),
        Interfaceable:new(
            Polygon:new({w = 80, h = 15}),
            self.build_button_handler)
        }))

    self.halt_button = registry:add(GameObject:new("civScard_halt_btn",{
        Transform:new(130,15),
        Renderable:new(
            Polygon:new({w = 80, h = 15}),
            nil,
            {20,20,20,240},
            "Halt"),
        Interfaceable:new(
            Polygon:new({w = 80, h = 15}),
            self.halt_button_handler)
        }))

    self.build_thermometer_text = registry:add(GameObject:new("civScard_therm_text",{
        Transform:new(50,0),
        Renderable:new(
            Polygon:new({w = 160, h = 30}),
            nil,
            {255,255,255,100},
            "No Unit in Production\n(Click to Build)"
            )
        }))
    self.build_thermometer_bg = registry:add(GameObject:new("civScard_therm_back",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({0,0 , 50,0 , 50,15+15 , 200+10,15+15 , 200+10,35+15 , 50,35+15 , 50,50 , 0,50}),
            nil,
            {120,30,30})
        }))

    self.build_thermometer_wrap = registry:add(GameObject:new("civScard_therm_wrap",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({5,5 , 45,5 , 45,20+15 , 195+10,20+15 , 195+10,30+15 , 45,30+15 , 45,45 , 5,45}),
            nil,
            {220,50,50})
        }))
    
    self.build_thermometer_progress = registry:add(GameObject:new("civScard_therm_top",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({5,5 , 45,5 , 45,20+15 , 195+10,20+15 , 195+10,30+15 , 35,30+15 , 5,45}),
            nil,
            {250,80,80})
        }))

    scenegraph:attach(self.root,nil)
    scenegraph:attachAll({
        self.bg_rect, 
        self.info_text, 
        self.shield}, self.root)
    scenegraph:attach(self.build_summary, self.bg_rect)
    scenegraph:attachAll({
        self.build_thermometer_bg, 
        self.build_thermometer_wrap, 
        self.build_thermometer_progress, 
        self.being_built_icon, 
        self.build_thermometer_text,
        self.build_button,
        self.halt_button}, self.build_summary)
    scenegraph:attach(self.title_rect, self.shield)
    scenegraph:detach(self.root,nil)

end

function CityInspectorSummaryCardView:show( curr_player, city_player, city )
    self.registry:getComponent(self.bg_rect,"Renderable").backgroundcolor = curr_player.midtone_color
    self.registry:getComponent(self.shield,"Renderable").backgroundcolor = curr_player.shadow_color
    local title = self.registry:getComponent(self.title_rect,"Renderable")
        title.backgroundcolor = city_player.highlight_color
        title.text = city.city_name

    self.scenegraph:detach(self.build_summary)
    if curr_player.player_name == city_player.player_name then
        self.scenegraph:attach(self.build_summary, self.bg_rect)
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
            if self.build_menu_view then
                --deconstruct old build menu if it exists
                self.scenegraph:detach(self.build_menu_view.root, nil)
                self.build_menu_viw = nil
            end
            self.build_menu_view = CityInspectorBuildMenuCardView:new(self.registry, self.scenegraph, nil, nil, function(value)
                self.scenegraph:detach(self.build_menu_view.root, nil)
                self.build_menu_view = nil
                print("Inset returned value " .. tostring(value))
                if value then
                    local spec = Global.Assets:getSpec(value)
                    self.registry:getComponent(self.being_built_icon,"Renderable").render = Global.Assets:getAsset(spec.icon_sprite)
                    self.registry:getComponent(self.build_thermometer_text,"Renderable").text = spec.army_description
                end
            end)
            self.scenegraph:attach(self.build_menu_view.root, self.root)
            --[[
            if city then
                print('Button pressed: building unit at city named ' .. city.city_name)
                self.registry:publish("IMMEDIATE_MUTATE", ProduceArmyMutator:new("SPEC_UNIT_MECH_1",city.address))
            end
            ]]--
        end)       
    end
end

return CityInspectorSummaryCardView