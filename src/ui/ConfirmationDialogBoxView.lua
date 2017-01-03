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
	self.root = registry:make("qcpv_root", {
		Transform:new(0,0)
	})
	self.scenegraph = scenegraph
	self.registry = registry

	local confirm_button_handler = TouchDelegate:new()
	local cancel_button_handler = TouchDelegate:new()
	local Block_Below_Delegate = TouchDelegate:new()

	confirm_button_handler:setHandler('onTouch', function(this, x, y)
		print('Confirmed!')
		self:hide()
		registry:publish('confirm')
		return true
	end)

	cancel_button_handler:setHandler('onTouch', function(this, x, y)
		print('Canceled!')
		self:hide()
		registry:publish('cancel')
		return true
	end)

	Block_Below_Delegate:setHandler('onTouch', function(this, x, y)
		return true
	end)

	local windowW = love.graphics:getWidth()
	local windowH = love.graphics:getHeight()

	local gray_out = registry:make("mmv_grayout", {
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({w = windowW, h = windowH}),
			nil,
			{0,0,0,128}),
		Interfaceable:new(
			Polygon:new({w = windowW, h = windowH}),
			Block_Below_Delegate)
	})
	
	local panelW = 300
	local panelH = 170
	local panelX = (windowW - panelW) / 2
	local panelY = (windowH - panelH) / 2
	local margin = 10
	local subPanelW = panelW - 2 * margin
	local btnH = 40
	local btnW = (subPanelW - margin)/ 2 

	local bg_rect = registry:make("qcpv_bg_rect", {
		Transform:new(panelX,panelY),
		Renderable:new(
			Polygon:new({w = panelW, h = panelH}),
			nil,
			{64, 128, 128,200}),
		})

	local text_panelH = panelH - 3 * margin - btnH

	local text_panel = registry:make("cdbv_text_panel",{
		Transform:new(margin, margin),
		Renderable:new(
			Polygon:new({w = subPanelW, h = text_panelH}),
			nil,
			{100,200,200},
			"Are you Sure?")
		})

	local buttonY = panelH - margin - btnH

	local confirm_btn = registry:make("cdbv_confirm_btn",{
		Transform:new(margin, buttonY),
		Renderable:new(
			Polygon:new({w = btnW, h = btnH}),
			nil,
			{100,200,200},
			"Confirm"),
		Interfaceable:new(
			Polygon:new({w = btnW, h = btnH}),
			confirm_button_handler)
		})

	local cancel_btnX = btnW + 2 * margin

	local cancel_btn = registry:make("cdbv_cancel_btn",{
		Transform:new(cancel_btnX, buttonY),
		Renderable:new(
			Polygon:new({w = btnW, h = btnH}),
			nil,
			{100,200,200},
			"Cancel"),
		Interfaceable:new(
			Polygon:new({w = btnW, h = btnH}),
			cancel_button_handler)
		})

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
		self.registry:get(self.text_panel, "Renderable").text = text
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