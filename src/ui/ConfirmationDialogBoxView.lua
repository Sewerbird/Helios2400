local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local ConfirmationDialogBoxView = class("ConfirmationDialogBoxView", {
	root = nil,
	is_attached = false,
	scenegraph = nil,

	my_prompt = nil,
	my_confirm = nil,
	my_cancel = nil
})

function ConfirmationDialogBoxView:init (registry, scenegraph, attachTo)
	self.root = registry:add(GameObject:new("qcpv_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph
	self.registry = registry

	local confirm_button_handler = TouchDelegate:new()
	local cancel_button_handler = TouchDelegate:new()
	local Block_Below_Delegate = TouchDelegate:new()

	confirm_button_handler:setHandler('onTouch', function(this, x, y)
		print('Confirmed!')
		self:hide()
		registry:publish('confirm')
	end)

	cancel_button_handler:setHandler('onTouch', function(this, x, y)
		print('Canceled!')
		self:hide()
		registry:publish('cancel')
	end)

	local gray_out = registry:add(GameObject:new("mmv_grayout", {
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({w = 1200, h = 800}),
			nil,
			{0,0,0,128}),
		Interfaceable:new(
			Polygon:new({w = 1200, h = 800}),
			Block_Below_Delegate)
	}))

	local bg_rect = registry:add(GameObject:new("qcpv_bg_rect", {
		Transform:new(600-150,400-75),
		Renderable:new(
			Polygon:new({w = 300, h = 150}),
			nil,
			{64, 128, 128,200}),
		}))

	local text_panel = registry:add(GameObject:new("cdbv_text_panel",{
		Transform:new(10, 10),
		Renderable:new(
			Polygon:new({w = 280, h = 80}),
			nil,
			{100,200,200},
			"Are you Sure?")
		}))

	local confirm_btn = registry:add(GameObject:new("cdbv_confirm_btn",{
		Transform:new(10, 100),
		Renderable:new(
			Polygon:new({w = 135, h = 40}),
			nil,
			{100,200,200},
			"Confirm"),
		Interfaceable:new(
			Polygon:new({w = 135, h = 40}),
			confirm_button_handler)
		}))

	local cancel_btn = registry:add(GameObject:new("cdbv_cancel_btn",{
		Transform:new(155, 100),
		Renderable:new(
			Polygon:new({w = 135, h = 40}),
			nil,
			{100,200,200},
			"Cancel"),
		Interfaceable:new(
			Polygon:new({w = 135, h = 40}),
			cancel_button_handler)
		}))

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(gray_out, self.root)
	self.scenegraph:attach(bg_rect, gray_out)
	self.scenegraph:attachAll({text_panel, confirm_btn, cancel_btn}, bg_rect)
	self.scenegraph:detach(self.root)

	self.my_cancel = cancel_btn
	self.my_confirm = confirm_btn
	self.text_panel = text_panel

end

function ConfirmationDialogBoxView:show ( attachTo, text )
	if not self.is_attached then
		self.registry:get(self.text_panel):getComponent("Renderable").text = text
		self.scenegraph:attach(self.root, attachTo)
		self.is_attached = true
	end
end

function ConfirmationDialogBoxView:hide ()
	if self.is_attached then
		self.scenegraph:detach(self.root)
		self.is_attached = false
	end
end

return ConfirmationDialogBoxView