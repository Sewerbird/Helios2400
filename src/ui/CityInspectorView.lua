local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local CityInspectorSummaryCardView = require 'src/ui/CityInspectorSummaryCardView'

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
    else
    	self:hide()
    	self:show(attachTo, city)
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