local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local SaveDirectoryView = class("SaveDirectoryView", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

local SaveGameDirectoryRow = class("SaveGameDirectoryRow", {
	root = nil,
	is_attached = false,
	scenegraph = nil
})

function SaveGameDirectoryRow:init (registry, scenegraph, path, row_num)
	self.root = registry:add(GameObject:new("sgdvr_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph

	local bg_rect = registry:add(GameObject:new("sgdvr_bg_rect", {
		Transform:new(5,5 + row_num * 40),
		Renderable:new(
			Polygon:new({ w = 300, h = 30 }),
			nil,
			{200,150,150},
			path)
		}))

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(bg_rect, self.root)
end

function SaveDirectoryView:getList (file_extension_filter)
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

function SaveDirectoryView:setMode (mode)
	if mode == "LOAD" then
		self.mode = "LOAD"
	elseif mode == "SAVE" then
		self.mode = "SAVE"
	end
end

function SaveDirectoryView:show (attachTo)
end

function SaveDirectoryView:hide ()
end

function SaveDirectoryView:refresh ()
end

function SaveDirectoryView:init (registry, scenegraph, file_extension_filter)
	self.root = registry:add(GameObject:new("qcpv_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph

	local saves = self:getList(".sav")

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(registry:add(GameObject:new("sgdv_bg_rect",{
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({ w = 310, h = 600}),
			nil,
			{100,200,200})
	})), self.root)
	for i, save in ipairs(saves) do
		self.scenegraph:attach(SaveGameDirectoryRow:new(registry,scenegraph,save,i-1).root, self.root)
	end

end

return SaveDirectoryView