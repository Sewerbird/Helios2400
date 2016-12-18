local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local ProduceArmyMutator = require 'src/mutate/mutator/ProduceArmyMutator'

local CityInspectorBuildMenuCardView = class("CityInspectorBuildMenuCardView", {
    root = nil,
    registry = nil,
    scenegraph = nil
})

function CityInspectorBuildMenuCardView:init (registry, scenegraph, city, player, onChoose)
    self.root = registry:add(GameObject:new("civScard", {
        Transform:new(0,0)
    }))

    self.registry = registry
    self.scenegraph = scenegraph
    self.callback = onChoose
    
    --[[Handlers]]--
    self.exit_button_handler = TouchDelegate:new()
    self.exit_button_handler:setHandler("onTouch",function(this, value)
        self:cancel(value)
    end)
    local bg_click_interceptor = TouchDelegate:new()
    bg_click_interceptor:setHandler('onTouch',function(this)
        return true
    end)

    --[[Components]]--

    self.inset = registry:add(GameObject:new("cibmc_inset",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({10,10 , 40,10 , 60,30 , 180,30 , 200,10 , 230,10 , 230,150 , 10,150}),
            nil,
            {30,30,30}--TODO: player shade color
            ),
        Interfaceable:new(
            Polygon:new({10,10 , 40,10 , 60,30 , 180,30 , 200,10 , 230,10 , 230,150 , 10,150}),
            bg_click_interceptor
            )
        }))
    self.instruct_rect = registry:add(GameObject:new("cibmc_instruction",{
        Transform:new(10,30),
        Renderable:new(
            Polygon:new({w = 220, h = 15}),
            nil,
            nil,
            "Choose a Unit To Build")
        }))

    self.choose_rect = registry:add(GameObject:new("cibmc_choose_rect",{
        Transform:new(10,45),
        Renderable:new(
            Polygon:new({w = 220, h = 105}),
            nil,
            {255,255,255,25} --TODO: player highlight color
            )
        }))
    self.money_rect = registry:add(GameObject:new("cibmc_money_rect",{
        Transform:new(0,0),
        Renderable:new(
            Polygon:new({10,10 , 40,10 , 60,30 , 10,30}),
            nil,
            {0,200,100},
            "$"..player.cash_balance)
        }))
    self.exit_rect = registry:add(GameObject:new("cibmc_exit_rect",{
        Transform:new(200,10),
        Renderable:new(
            Polygon:new({0,0 , 30,0 , 30,20 , -20,20}),
            nil,
            {180, 50, 0},
            "Exit"),
        Interfaceable:new(
            Polygon:new({0,0 , 30,0 , 30,20 , -20,20}),
            self.exit_button_handler)
        }))


    scenegraph:attach(self.root,nil)
    scenegraph:attachAll({
        self.inset, 
        self.instruct_rect,
        self.choose_rect,
        self.money_rect,
        self.exit_rect}, self.root)

    local specs = Global.Assets:getAllPlayerUnitSpecs()

    print(inspect(specs))
    for row = 1, 2 do
        for col = 1, 4 do
            local spec = specs[(((row-1) * 4) + col)]

            local select_this_one = TouchDelegate:new()
            select_this_one:setHandler("onTouch", function(this, x, y)
                if player.cash_balance >= spec.base_cash_cost then
                    self:choose(spec)
                else
                    print("Not enough cash, honey")
                end
            end)
            self["slot_" .. row .. "_" .. col] = registry:add(GameObject:new("cibmc_slot",{
                Transform:new( (col-1)*55 + 2, (row-1)*51 +2),
                Renderable:new(
                    Polygon:new({w = 50, h = 50}),
                    nil,
                    {255,255,255,25}
                    ),
                Interfaceable:new(
                    Polygon:new({w = 50, h = 50}),
                    select_this_one)
            }))
            self["slot_" .. row .. "_" .. col .. "_img"] = registry:add(GameObject:new("cibmc_slot_img",{
                Transform:new(12,5),
                Renderable:new(
                    Polygon:new({w = 25, h = 30}),
                    (spec and Global.Assets:getAsset(spec.icon_sprite)) or nil,
                    {255,255,255,25}
                    )
            }))
            self["slot_" .. row .. "_" .. col .. "_cost"] = registry:add(GameObject:new("cibmc_slot_cost",{
                Transform:new(0,35),
                Renderable:new(
                    Polygon:new({w = 50, h = 15}),
                    nil,
                    player.cash_balance >= (spec and spec.base_cash_cost or 0) and {200,255,200,100} or {255,200,200,100},
                    spec and spec.base_cash_cost or ""
                    )
            }))
            self["slot_" .. row .. "_" .. col .. "_grayout"] = registry:add(GameObject:new("cibmc_slot_grayout",{
                Transform:new(0,0),
                Renderable:new(
                    Polygon:new({w = 50, h = 50}),
                    nil,
                    {0,0,0,64}
                    )
            }))
            scenegraph:attach(self["slot_" .. row .. "_" .. col],self.choose_rect)
            scenegraph:attach(self["slot_" .. row .. "_" .. col .. "_cost"], self["slot_" .. row .. "_" .. col])
 
            if spec and player.cash_balance < spec.base_cash_cost then
                scenegraph:attach(self["slot_" .. row .. "_" .. col .. "_img"], self["slot_" .. row .. "_" .. col])
                scenegraph:attach(self["slot_" .. row .. "_" .. col .. "_grayout"], self["slot_" .. row .. "_" .. col])
            elseif spec then
                scenegraph:attach(self["slot_" .. row .. "_" .. col .. "_img"], self["slot_" .. row .. "_" .. col])
                scenegraph:attach(self["slot_" .. row .. "_" .. col .. "_grayout"], self["slot_" .. row .. "_" .. col])
                scenegraph:detach(self["slot_" .. row .. "_" .. col .. "_grayout"])
            end
            
        end
    end
    scenegraph:detach(self.root,nil)

end

function CityInspectorBuildMenuCardView:cancel( value )
    print('cancelling build')
    self.callback(nil)
end

function CityInspectorBuildMenuCardView:choose( value )
    print('building ' .. inspect(value))
    self.callback(value)
end

return CityInspectorBuildMenuCardView