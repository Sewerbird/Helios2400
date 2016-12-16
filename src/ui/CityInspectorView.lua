local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local ProduceArmyMutator = require 'src/mutate/mutator/ProduceArmyMutator'

local CityInspectorView = class("CityInspectorView", {
	root = nil,
	is_attached = false,
	scenegraph = nil,
    cityInfo = nil
})

function CityInspectorView:init (registry, scenegraph)
	self.root = registry:add(GameObject:new("civ_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph
	self.registry = registry

	local bg_rect = registry:add(GameObject:new("civ_bg_rect", {
		Transform:new(125,0),
		Renderable:new(
			Polygon:new({w = 500, h = 125}),
			nil,
			{80,80,80,200},
			"CITY INSPECTOR VIEW")
		}))
    
    local info_rect = registry:add(GameObject:new("civ_info_rect", {
    	Transform:new(0,10),
    	Renderable:new(
    		Polygon:new({w=200, h = 115}),
    		nil,
    		{90,100,100},
    		"Info about the city goes here\n Like its name: \n And owner: \n and address perhaps.\n Population?")
    	}))

    local build_rect = registry:add(GameObject:new("civ_build_rect", {
    	Transform:new(200,10),
    	Renderable:new(
    		Polygon:new({w=150, h = 115}),
    		nil,
    		{90,100,100})
    	}))

    local build_info = registry:add(GameObject:new("civ_build_info",{
    	Transform:new(0,0),
    	Renderable:new(
    		Polygon:new({w=150, h = 75}),
    		nil,
    		{120,150,150},
    		"Currently Building Nothing")
    	}))
    local debug_build_button_handler = TouchDelegate:new()
    debug_build_button_handler:setHandler('onTouch', function(this, x, y)
        if self.cityInfo then
            print('Button pressed: building unit at city named ' .. self.cityInfo.city_name)
            registry:publish("IMMEDIATE_MUTATE", ProduceArmyMutator:new("SPEC_UNIT_MECH_1",self.cityInfo.address))
        end
    end)
    local build_btn = registry:add(GameObject:new("civ_build_btn", {
    	Transform:new(5,80),
    	Renderable:new(
    		Polygon:new({w=65, h = 30}),
    		nil,
    		{200,200,200},
    		"BUILD"),
        Interfaceable:new(
            Polygon:new({w=65, h = 30}),
            debug_build_button_handler)
    	}))
    local stop_build_btn = registry:add(GameObject:new("civ_stop_build_btn", {
    	Transform:new(75,80),
    	Renderable:new(
    		Polygon:new({w=65, h = 30}),
    		nil,
    		{200,200,200},
    		"HALT")
    	}))
    local aux_rect = registry:add(GameObject:new("civ_aux_rect", {
    	Transform:new(350,10),
    	Renderable:new(
    		Polygon:new({w = 150, h = 115}),
    		nil,
    		{90,100,10})
    	}))
    local aux_info = registry:add(GameObject:new("civ_aux_info",{
    	Transform:new(5,0),
    	Renderable:new(
    		Polygon:new({w = 140, h = 105}),
    		nil,
    		{200,200,200})
    	}))


	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attachAll({bg_rect}, self.root)
	self.scenegraph:attachAll({info_rect, build_rect, aux_rect}, bg_rect)
	self.scenegraph:attachAll({build_info, build_btn, stop_build_btn}, build_rect)
	self.scenegraph:attachAll({aux_info}, aux_rect)
	self.scenegraph:detach(self.root)

	self.info_rect = info_rect
	self.build_info = build_info
    self.build_rect = build_rect
	self.aux_info = aux_info
end

function CityInspectorView:show ( attachTo, city )
	if not self.is_attached then
		local cityInfo = self.registry:get(city.gamestate):getComponent("GameInfo")
		local cityName = cityInfo.city_name
		local cityOwner = cityInfo.owner
		local cityAddress = cityInfo.address
		local cityPlanet = cityInfo.map
		local cityAge = cityInfo.turns_owned[cityOwner]

        self.cityInfo = cityInfo
		self.registry:get(self.info_rect):getComponent("Renderable").text = (cityName or "none") .. "\n" .. (cityOwner or "none") .. "\n" .. cityPlanet .. " : " .. cityAddress .. "\n" .. (cityOwner or "none") .. "'s for " .. (cityAge or 0) .. " turns"
		self.scenegraph:attach(self.root, attachTo)
		self.is_attached = true
	end
end

function CityInspectorView:hide ()
	if self.is_attached then
		self.scenegraph:detach(self.root)
		self.is_attached = false
        self.cityInfo = nil
	end
end

return CityInspectorView