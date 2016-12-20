local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local SaveSlotsDirectoryView = class("SaveSlotsDirectoryView", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

local SaveSlotView = class("SaveSlotView", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

function SaveSlotView:init (registry, scenegraph, path, row_num, click_handler)
	self.root = registry:add(GameObject:new("sgdvr_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph

	local bg_rect = registry:add(GameObject:new("sgdvr_bg_rect", {
		Transform:new(5, 10 + row_num * 40),
		Renderable:new(
			Polygon:new({ w = 290, h = 30 }),
			nil,
			{200,150,150},
			path),
		Interfaceable:new(
			Polygon:new({ w = 290, h = 30 }),
			click_handler)
		}))

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(bg_rect, self.root)
end

function SaveSlotsDirectoryView:getList (file_extension_filter)
	local rootpath = "" --TODO: make a .sav and .scn subdirectory
	local saves = {}
	for i,v in ipairs(love.filesystem.getDirectoryItems("")) do
		if file_extension_filter and string.sub(v,-string.len(file_extension_filter))==file_extension_filter then
			local filePath = rootpath .. v
			table.insert(saves, filePath)
		end
	end
	return saves
end

function SaveSlotsDirectoryView:setMode (mode)
	if mode == "LOAD" then
		self.mode = "LOAD"
	elseif mode == "SAVE" then
		self.mode = "SAVE"
	else
		error("Bad mode given to save slots view: " .. tostring(mode))
	end
end

function SaveSlotsDirectoryView:show (attachTo, save_or_load_mode)
	self:setMode(save_or_load_mode)
	self.saves = self:getList(".sav")
	if not self.is_attached then
		self.scenegraph:attach(self.root, attachTo)
	end
end

function SaveSlotsDirectoryView:hide ()
	self.scenegraph:detach(self.root)
end

function SaveSlotsDirectoryView:refresh ()
end

function SaveSlotsDirectoryView:doAction ( action, slot )
	print("Click will cause a " .. action .. " on slot " .. slot)
	if action == "LOAD" then
		self.registry:publish("IMMEDIATE_LOAD_GAME","save_slot_" .. slot)
	elseif action == "SAVE" then
		self.registry:publish("IMMEDIATE_SAVE_GAME","save_slot_" .. slot)
	end
end

function SaveSlotsDirectoryView:init (registry, scenegraph, file_extension_filter, save_or_load_mode)
	self.root = registry:add(GameObject:new("qcpv_root", {
		Transform:new(50,120)
	}))
	self.scenegraph = scenegraph
	self.registry = registry
	self.mode = save_or_load_mode

	self.saves = self:getList(".sav")

	local Block_Below_Delegate = TouchDelegate:new()
	Block_Below_Delegate:setHandler('onTouch', function(this, x, y)
		print('Blocking event')
    	return true
    end)

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(registry:add(GameObject:new("sgdv_bg_rect",{
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({ w = 300, h = 300}),
			nil,
			{100,200,200}),
		Interfaceable:new(
			Polygon:new({ w = 300, h = 300}),
			Block_Below_Delegate)
	})), self.root)

	for i = 1, 5 do
		local click_handler = TouchDelegate:new()
		local slot_in_use = false
		for j, sav in ipairs(self.saves) do
			if sav == ("save_slot_" .. i ..".sav") then
				print("\nwooo\n")
				slot_in_use = true
			else
				print("SAVE in list is '" .. sav .. "' " .. i .. ":" .. tostring(sav == ("save_slot_" .. i ..".sav")))
			end
		end
		click_handler:setHandler("onTouch", function(this, x, y)
			if (slot_in_use and (self.mode == "LOAD")) or (self.mode == "SAVE") then
				self:doAction(self.mode, i)
			end
		end)
		local slot_name = slot_in_use and "In Use" or "[Empty]"
		self.scenegraph:attach(SaveSlotView:new(registry,scenegraph, slot_name ,i-1, click_handler).root, self.root)
	end

	--[[
	for i, save in ipairs(saves) do
		self.scenegraph:attach(SaveSlotView:new(registry,scenegraph,save,i-1).root, self.root)
	end
	]]--

	local close_btn_handler = TouchDelegate:new()
	close_btn_handler:setHandler("onTouch",function(this,x,y)
		self:hide()
	end)

	local close_btn = registry:add(GameObject:new("sgdvr_close_btn",{
		Transform:new(5, 10 + 6 * 40),
		Renderable:new(
			Polygon:new({ w = 290, h = 40}),
			nil,
			{244,20,20},
			"Cancel"),
		Interfaceable:new(
			Polygon:new({ w = 290, h = 40}),
			close_btn_handler)
		}))

	self.scenegraph:attach(close_btn, self.root)

end

return SaveSlotsDirectoryView