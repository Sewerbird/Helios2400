local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'
local SaveSlotsDirectoryView = require 'src/ui/SaveSlotsDirectoryView'

local color_pallete = {
	shadow = {4, 3, 3},
	dark = {26, 58, 58},
	midtone = {113, 103, 124},
	alttone = {106, 123, 118},
	highlight = {196,231,212},
	bright = {209, 213, 222}
}

local MainMenuView = class("MainMenuView", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

function MainMenuView:init (registry, scenegraph)
	self.root = registry:make("mmv_root", {
		Transform:new(0,0)
	})
	self.scenegraph = scenegraph
	self.registry = registry

	self.save_view = SaveSlotsDirectoryView:new(registry, scenegraph,".sav")

	local save_button_handler = TouchDelegate:new()
	save_button_handler:setHandler('onTouch', function(this, x, y)
		self.save_view:show(self.bg_rect, "SAVE")
		print('Button pressed: save')
	end)
	local load_button_handler = TouchDelegate:new()
	load_button_handler:setHandler('onTouch', function(this, x, y)
		self.save_view:show(self.bg_rect, "LOAD")
		print('Button pressed: load.')
	end)
	local return_button_handler = TouchDelegate:new()
	return_button_handler:setHandler('onTouch', function(this, x, y)
		self.scenegraph:detach(self.root)
		self.is_attached = false
		print('Button pressed: return')
	end)
	local quit_button_handler = TouchDelegate:new()
	quit_button_handler:setHandler('onTouch', function(this, x, y)
		love.event.quit()
	end)
	local switch_next_handler = TouchDelegate:new()
	switch_next_handler:setHandler('onTouch', function(this, x, y)
		registry:publish("ui/debug_nextscene")
		self:hide()
	end)
	local switch_prev_handler = TouchDelegate:new()
	switch_prev_handler:setHandler('onTouch', function(this, x, y)
		registry:publish("ui/debug_prevscene")
		self:hide()
	end)

	local Block_Below_Delegate = TouchDelegate:new()
	Block_Below_Delegate:setHandler('onTouch', function(this, x, y)
		print('Blocking event')
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

	local panelW = 400
	local panelH = 600
	local panelX = ( windowW - panelW ) / 2
	local panelY = ( windowH - panelH ) / 2
	local margin = 10

	local bg_rect = registry:make("mmv_bgrect", {
		Transform:new(panelX,panelY),
		Renderable:new(
			Polygon:new({w = panelW, h = panelH}),
			nil,
			{color_pallete.shadow[1],color_pallete.shadow[2],color_pallete.shadow[3],200})
		})

	local subPanelW = panelW - 2 * margin
	local buttonW = subPanelW - 2 * margin
	local titleH = 40
	local title_panel = registry:make("mmv_title",{
		Transform:new(margin,margin),
		Renderable:new(
			Polygon:new({w = subPanelW, h = titleH}),
			nil,
			color_pallete.dark,
			"HELIOS 2400 DEBUG MENU")
		})

	local saveLoadY = titleH + 2 * margin
	local buttonH = 30
	local bigMargin = 40
	local saveLoadH = buttonH * 4 + margin * 4 + bigMargin
	local saveload_panel = registry:make("mmv_saveloadpanel",{
		Transform:new(margin,saveLoadY),
		Renderable:new(
			Polygon:new({w = subPanelW, h = saveLoadH}),
			nil,
			color_pallete.dark)
		})

	local save_btn = registry:make("mmv_save_btn",{
		Transform:new(margin, margin),
		Renderable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			nil,
			color_pallete.midtone,
			"Save Game"),
		Interfaceable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			save_button_handler)
		})

	local load_btn = registry:make("mmv_load_btn",{
		Transform:new(margin, margin + buttonH + margin),
		Renderable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			nil,
			color_pallete.midtone,
			"Load Game"),
		Interfaceable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			load_button_handler)
		})

	local quit_btn = registry:make("mmv_quit_btn",{
		Transform:new(margin , margin + (buttonH + margin) * 2),
		Renderable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			nil,
			color_pallete.midtone,
			"Quit Game"),
		Interfaceable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			quit_button_handler)
		})

	local return_btn = registry:make("mmv_return_btn",{
		Transform:new(margin , margin + buttonH * 3 + margin * 2 + bigMargin),
		Renderable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			nil,
			color_pallete.midtone,
			"Return (or press Escape)"),
		Interfaceable:new(
			Polygon:new({w = buttonW, h = buttonH}),
			return_button_handler)
		})
	local switchButtonH = 60
	local view_switcher_panelH = switchButtonH + 2 * margin
	local view_switcher_panelY = saveLoadY + saveLoadH + margin
	local view_switcher_panel = registry:make("mmv_switcher_panel",{
		Transform:new(margin,view_switcher_panelY),
		Renderable:new(
			Polygon:new({w = subPanelW, h = view_switcher_panelH}),
			nil,
			color_pallete.dark,
			nil)
		})

	local switchButtonW = (subPanelW - 3 * margin) / 2

	local AHO = switchButtonH/4
	local AHW = switchButtonW/4
	local prevPoly = Polygon:new({
				0,switchButtonH/2,
				AHW,0,
				AHW,AHO,
				switchButtonW,AHO,
				switchButtonW,switchButtonH-AHO,
				AHW,switchButtonH-AHO,
				AHW,switchButtonH}
				)
	local switch_prev_btn = registry:make("mmv_switchprev_btn",{
		Transform:new(margin,margin),
		Renderable:new(
			prevPoly,
			nil,
			color_pallete.midtone,
			"Previous View"),
		Interfaceable:new(
			prevPoly,
			switch_prev_handler)
		})

	local nextPoly = Polygon:new({
				switchButtonW,switchButtonH/2,
				switchButtonW - AHW,0,
				switchButtonW - AHW,AHO,
				0,AHO,
				0,switchButtonH-AHO,
				switchButtonW - AHW,switchButtonH-AHO,
				switchButtonW - AHW,switchButtonH}
				)
	local switch_next_btn = registry:make("mmv_switchnext_btn",{
		Transform:new(2 * margin + switchButtonW,margin),
		Renderable:new(
			nextPoly,
			nil,
			color_pallete.midtone,
			"Next View"),
		Interfaceable:new(
			nextPoly,
			switch_next_handler)
		})

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attachAll({gray_out, bg_rect}, self.root)

	self.scenegraph:attachAll({title_panel, saveload_panel, view_switcher_panel}, bg_rect)
	self.scenegraph:attachAll({save_btn, load_btn, return_btn, quit_btn}, saveload_panel)
	self.scenegraph:attachAll({switch_next_btn, switch_prev_btn}, view_switcher_panel)
	self.scenegraph:detach(self.root)

	self.save_view:hide()

	self.bg_rect = bg_rect

	self.registry:subscribe("IMMEDIATE_SAVE_GAME",function(this,msg)
		self.save_view:hide()
	end)
	self.registry:subscribe("IMMEDIATE_LOAD_GAME",function(this,msg)
		self.save_view:hide()
	end)
end

function MainMenuView:show( attachTo )
	if not self.is_attached then
		self.scenegraph:attach(self.root, attachTo)
		self.is_attached = true
	end
end

function MainMenuView:hide()
	if self.is_attached then
		self.scenegraph:detach(self.root)
		self.is_attached = false
	end
end

return MainMenuView