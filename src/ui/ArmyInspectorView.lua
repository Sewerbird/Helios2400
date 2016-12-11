local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local ArmyInspectorView = class("ArmyInspectorView", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

function ArmyInspectorView:init (registry, scenegraph)
	self.root = registry:add(GameObject:new("aiv_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph

	local end_turn_button_handler = TouchDelegate:new()
	end_turn_button_handler:setHandler('onTouch', function(this, x, y)
		print('Ending turn')
		registry:publish(self.root .. ':endTurnRequest')
		return true
	end)

	local bg_rect = registry:add(GameObject:new("aiv_bg_rect", {
		Transform:new(625,0),
		Renderable:new(
			Polygon:new({w = 500, h = 125}),
			nil,
			{80,80,80,200},
			"ARMY INSPECTOR VIEW")
		}))
    
    local info_rect = registry:add(GameObject:new("aiv_info_rect", {
    	Transform:new(0,10),
    	Renderable:new(
    		Polygon:new({w=200, h = 115}),
    		nil,
    		{100,100,90},
    		"Info about the unit goes here\n Like its name: \n And owner: \n and address perhaps.\n 10/10 hp?")
    	}))



	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attachAll({bg_rect}, self.root)
	self.scenegraph:attachAll({info_rect}, bg_rect)
	self.scenegraph:detach(self.root)

end

function ArmyInspectorView:show ( attachTo, city )
	if not self.is_attached then
		print("Switching to city " .. tostring(city))
		self.scenegraph:attach(self.root, attachTo)
		self.is_attached = true
	end
end

function ArmyInspectorView:hide ()
	if self.is_attached then
		self.scenegraph:detach(self.root)
		self.is_attached = false
	end
end

return ArmyInspectorView