local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local color_pallete = {
	shadow = {4, 3, 30},
	dark = {26, 58, 58},
	midtone = {113, 103, 124},
	alttone = {106, 123, 118},
	highlight = {196,231,212},
	bright = {209, 213, 222}
}

local width = 400
local height = 300
local margin = 10

local ConfirmActionDialog = class("ConfirmActionDialog", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

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

function ConfirmActionDialog:init (registry, scenegraph, text, ok_cb, no_cb)
	self.root = registry:make("sgdvr_root", {
		Transform:new(0,0)
	})
	self.scenegraph = scenegraph
	self.registry = registry

	self.block_handler = TouchDelegate:new()
	self.block_handler:setHandler('onTouch', function(this, x, y)
		return true
	end)

	self.okay_handler = TouchDelegate:new()
	self.okay_handler:setHandler('onTouch',function(this, x, y)
		self:hide()
		ok_cb()
	end)
	self.cancel_handler = TouchDelegate:new()
	self.cancel_handler:setHandler('onTouch',function(this, x, y)
		self:hide()
		no_cb()
	end)

	self.bg_rect = registry:make("sgdvr_bg_rect", {
		Transform:new(0, 0),
		Renderable:new(
			Polygon:new({ w = width - 2 * margin, h = height }),
			nil,
			color_pallete.dark,
			text),
		Interfaceable:new(
			Polygon:new({ w = width, h = height }),
			self.block_handler)
		})

	local okay_rect = registry:make("cad_okay_rect", {
		Transform:new(margin, 30),
		Renderable:new(
			Polygon:new({ w = width / 2 - 2 * margin - margin / 2, h = 30}),
			nil,
			color_pallete.midtone,
			"Confirm"),
		Interfaceable:new(
			Polygon:new({ w = width / 2 - 2 * margin - margin / 2, h = 30}),
			self.okay_handler)
	})

	local cancel_rect = registry:make("cad_cancel_rect", {
		Transform:new(width/2 - margin/2, 30),
		Renderable:new(
			Polygon:new({ w = width / 2 - 2 * margin - margin / 2, h = 30}),
			nil,
			color_pallete.midtone,
			"Cancel"),
		Interfaceable:new(
			Polygon:new({ w = width / 2 - 2 * margin - margin / 2, h = 30}),
			self.cancel_handler)
	})

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(self.bg_rect, self.root)
	self.scenegraph:attachAll({okay_rect, cancel_rect}, self.bg_rect)
end

function ConfirmActionDialog:show(attachTo)
	self.scenegraph:attach(self.root, attachTo)
end

function ConfirmActionDialog:hide()
	self.scenegraph:detach(self.root)
end
function ConfirmActionDialog:refresh(text, ok_cb, no_cb)
	self.okay_handler:setHandler("onTouch", function () 
		ok_cb()
		self:hide()
	end)
	self.cancel_handler:setHandler("onTouch", function () 
		no_cb()
		self:hide()
	end)
	self.registry:get(self.bg_rect, "Renderable").text = text
end


function SaveSlotView:init (registry, scenegraph, path, row_num, click_handler)
	self.root = registry:make("sgdvr_root", {
		Transform:new(0,0)
	})
	self.scenegraph = scenegraph
	self.registry = registry

	local bg_rect = registry:make("sgdvr_bg_rect", {
		Transform:new(10, 10 + row_num * 40),
		Renderable:new(
			Polygon:new({ w = 360, h = 30 }),
			nil,
			color_pallete.midtone,
			path),
		Interfaceable:new(
			Polygon:new({ w = 360, h = 30 }),
			click_handler)
		})

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(bg_rect, self.root)
end

function SaveSlotsDirectoryView:init (registry, scenegraph, file_extension_filter, save_or_load_mode)
	self.root = registry:make("qcpv_root", {
		Transform:new(10,60)
	})
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


	self.scenegraph:attach(registry:make("sgdv_bg_rect",{
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({ w = width - 2 * margin, h = height}),
			nil,
			color_pallete.dark),
		Interfaceable:new(
			Polygon:new({ w = width - 2 * margin, h = height}),
			Block_Below_Delegate)
	}), self.root)
	self.anchor = registry:make("listanchor",{
		Transform:new(0,0)
	})
	self.scenegraph:attach(self.anchor,self.root)

	--self:reList()

	local close_btn_handler = TouchDelegate:new()
	close_btn_handler:setHandler("onTouch",function(this,x,y)
		self:hide()
	end)

	local close_btn = registry:make("sgdvr_close_btn",{
		Transform:new(10, 10 + 6 * 40),
		Renderable:new(
			Polygon:new({ w = 360, h = 40}),
			nil,
			color_pallete.midtone,
			"Cancel"),
		Interfaceable:new(
			Polygon:new({ w = 360, h = 40}),
			close_btn_handler)
		})

	self.scenegraph:attach(close_btn, self.root)

	self.confirmation = ConfirmActionDialog:new(
		self.registry,
		self.scenegraph,
		"Are you sure?",
		function() 
			print("CONFIRMED")
		end, 
		function() 
			print("CANCELLED")
		end)

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
		self:reList()
	end
end

function SaveSlotsDirectoryView:reList()
	self.scenegraph:detachAll(self.scenegraph:getChildren(self.anchor))
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
		local slot_name = slot_in_use and ("Save Slot " .. "[In Use]") or ("Save Slot " .. "[Empty]")
		self.scenegraph:attach(SaveSlotView:new(self.registry,self.scenegraph, slot_name ,i-1, click_handler).root, self.anchor)
	end
end

function SaveSlotsDirectoryView:hide ()
	self.scenegraph:detach(self.root)
end

function SaveSlotsDirectoryView:refresh ()
end

function SaveSlotsDirectoryView:doAction ( action, slot )
	print("Click will cause a " .. action .. " on slot " .. slot)
	self.confirmation:refresh("Are you sure you wish to " .. action .. "?", 
		function() 
			if action == "LOAD" then
				self.registry:publish("IMMEDIATE_LOAD_GAME","save_slot_" .. slot)
				Global.Loader:debugLoad("save_slot_" .. slot)
			elseif action == "SAVE" then
				self.registry:publish("IMMEDIATE_SAVE_GAME","save_slot_" .. slot)
				Global.Loader:saveGame("save_slot_" .. slot , self.registry)
				self:show(nil, action)
			end
		end, 
		function() 
		end)
	self.confirmation:show(self.root)
end

return SaveSlotsDirectoryView