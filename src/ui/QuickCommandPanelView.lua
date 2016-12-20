local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local QuickCommandPanelView = class("QuickCommandPanelView", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

function QuickCommandPanelView:init (registry, scenegraph)
	self.root = registry:add(GameObject:new("qcpv_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph

	local end_turn_button_handler = TouchDelegate:new()
	end_turn_button_handler:setHandler('onTouch', function(this, x, y)
		print('Ending turn')
		registry:publish(self.root .. ':endTurnRequest')
		return true
	end)

	local bg_rect = registry:add(GameObject:new("qcpv_bg_rect", {
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({w = 125, h = 125}),
			nil,
			{64, 128, 128}):bindTo("beginTurn", function (this, cmp, msg)
			cmp.backgroundcolor = msg.midtone_color
        end)
		}))

	local end_turn_btn = registry:add(GameObject:new("qcpv_end_turn_btn",{
		Transform:new(10, 10),
		Renderable:new(
			Polygon:new({w = 105, h = 105}),
			nil,
			{150,200,200},
			"Quit Turn"
		):bindTo("beginTurn", function (this, cmp, msg)
			cmp.text = "Quit " .. msg.player_name .. "'s Turn"
			cmp.backgroundcolor = msg.highlight_color
        end),
		Interfaceable:new(
			Polygon:new({w = 105, h = 105}),
			end_turn_button_handler)
		}))


	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attachAll({bg_rect}, self.root)
	self.scenegraph:attachAll({end_turn_btn}, bg_rect)
	--self.scenegraph:detach(self.root)
end

return QuickCommandPanelView