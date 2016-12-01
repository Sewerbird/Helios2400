local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local MainMenuView = class("MainMenuView", {
	root = nil
})

function MainMenuView:init (registry, scenegraph)
	self.root = registry:add(GameObject:new("mmv_root", {
		Transform:new(0,0)
	}))

	local save_button_handler = TouchDelegate:new()
	save_button_handler:setHandler('onTouch', function(this, x, y)
		print('Button pressed: save')
	end)
	local load_button_handler = TouchDelegate:new()
	load_button_handler:setHandler('onTouch', function(this, x, y)
		print('Button pressed: load')
	end)
	local return_button_handler = TouchDelegate:new()
	return_button_handler:setHandler('onTouch', function(this, x, y)
		print('Button pressed: return')
	end)

	local Block_Below_Delegate = TouchDelegate:new()
	Block_Below_Delegate:setHandler('onTouch', function(this, x, y)
		print('Blocking event')
    	return true
    end)

	local gray_out = registry:add(GameObject:new("mmv_grayout", {
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({w = 1200, h = 800}),
			nil,
			{0,0,0,128},
			math.floor(math.random()*100000)),
		Interfaceable:new(
			Polygon:new({w = 1200, h = 800}),
			Block_Below_Delegate)
	}))

	local bg_rect = registry:add(GameObject:new("mmv_bgrect", {
		Transform:new(400,100),
		Renderable:new(
			Polygon:new({w = 400, h = 600}),
			nil,
			{128, 60, 128})
		}))

	local title_panel = registry:add(GameObject:new("mmv_title",{
		Transform:new(50,20),
		Renderable:new(
			Polygon:new({w = 300, h = 80}),
			nil,
			{200,100,200},
			"HELIOS 2400 DEBUG MENU")
		}))

	local saveload_panel = registry:add(GameObject:new("mmv_saveloadpanel",{
		Transform:new(50,120),
		Renderable:new(
			Polygon:new({w = 300, h = 130}),
			nil,
			{200,100,200})
		}))

	local save_btn = registry:add(GameObject:new("mmv_save_btn",{
		Transform:new(10, 10),
		Renderable:new(
			Polygon:new({w = 280, h = 30}),
			nil,
			{150,100,180},
			"Save Game"),
		Interfaceable:new(
			Polygon:new({w = 280, h = 30}),
			save_button_handler)
		}))

	local load_btn = registry:add(GameObject:new("mmv_load_btn",{
		Transform:new(10, 50),
		Renderable:new(
			Polygon:new({w = 280, h = 30}),
			nil,
			{150,100,180},
			"Load Game"),
		Interfaceable:new(
			Polygon:new({w = 280, h = 30}),
			load_button_handler)
		}))

	local return_btn = registry:add(GameObject:new("mmv_return_btn",{
		Transform:new(10,90),
		Renderable:new(
			Polygon:new({w = 280, h = 30}),
			nil,
			{150,100,180},
			"Return"),
		Interfaceable:new(
			Polygon:new({w = 280, h = 30}),
			return_button_handler)
		}))


	scenegraph:attach(self.root, nil)
	scenegraph:attachAll({gray_out, bg_rect}, self.root)
	scenegraph:attachAll({title_panel, saveload_panel}, bg_rect)
	scenegraph:attachAll({save_btn, load_btn, return_btn}, saveload_panel)
	scenegraph:detach(self.root)
end

return MainMenuView