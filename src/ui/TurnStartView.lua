local class = require 'lib/30log'
local GameObject = require 'src/GameObject'
local Transform = require 'src/component/Transform'
local Renderable = require 'src/component/Renderable'
local Interfaceable = require 'src/component/Interfaceable'
local Polygon = require 'src/datatype/Polygon'
local TouchDelegate = require 'src/datatype/TouchDelegate'

local TurnStartView = class("TurnStartView", {
	root = nil,
	scenegraph = nil
})

function TurnStartView:init (registry, scenegraph, attachTo)
	self.root = registry:add(GameObject:new("tsv_root", {
		Transform:new(0,0)
	}))
	self.scenegraph = scenegraph
	self.registry = registry

	local start_button_handler = TouchDelegate:new()
	local Block_Below_Delegate = TouchDelegate:new()

	start_button_handler:setHandler('onTouch', function(this, x, y)
		print("Let's go!")
		self:hide()
	end)

	local gray_out = registry:add(GameObject:new("tsv_grayout", {
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({w = 1200, h = 800}),
			nil,
			{10,20,30,255}),
		Interfaceable:new(
			Polygon:new({w = 1200, h = 800}),
			Block_Below_Delegate)
	}))

	local bg_rect = registry:add(GameObject:new("tsv_bg_rect", {
		Transform:new(600-150,400-95),
		Renderable:new(
			Polygon:new({w = 300, h = 170}),
			nil,
			{64, 128, 128,200}),
		}))

	local text_panel = registry:add(GameObject:new("tsv_text_panel",{
		Transform:new(10, 10),
		Renderable:new(
			Polygon:new({w = 280, h = 100}),
			nil,
			{100,200,200},
			"Your Turn")
		}))

	local start_btn = registry:add(GameObject:new("tsv_confirm_btn",{
		Transform:new(10, 120),
		Renderable:new(
			Polygon:new({w = 280, h = 40}),
			nil,
			{100,200,200},
			"Begin"),
		Interfaceable:new(
			Polygon:new({w = 280, h = 40}),
			start_button_handler)
		}))

	self.scenegraph:attach(self.root, nil)
	self.scenegraph:attach(gray_out, self.root)
	self.scenegraph:attach(bg_rect, gray_out)
	self.scenegraph:attachAll({text_panel, start_btn}, bg_rect)
	self.scenegraph:detach(self.root)

	self.text_panel = text_panel
	self.bg_rect = bg_rect
	self.start_btn = start_btn
	self.gray_out = gray_out

	self.registry:subscribe("byzantiumOwned", function(this, msg)
		local tp = self.registry:get(self.text_panel):getComponent("Renderable")
		self.byzantium_text = "BYZANTIUM has been owned by " .. msg.player.player_name .. " for " .. msg.byzantium.turns_owned[msg.player.player_name] .." turns!\n They will win if they hold the throne for another " .. (5-msg.byzantium.turns_owned[msg.player.player_name]) .. "!"
	end)

	self.registry:subscribe("gameOverByzantiumWin", function(this, msg)
		local tp = self.registry:get(self.text_panel):getComponent("Renderable")
		self.gameover_winner = msg.player.player_name
		self.gameover_winner_text = "Congratulations, sir:\nBYZANTIUM has been held for 5 turns by " .. self.gameover_winner .. "!\n\nGAME WON, Sir!"
		self.gameover_loser_text = "I am sorry, but...\n" .. msg.player.player_name .. " has held BYZANTIUM for 5 turns!\n GAME OVER, Sir..."
		self.scenegraph:detach(self.start_btn)
	end)
end

function TurnStartView:show ( attachTo, player )
	if not self.is_attached then
		local tp = self.registry:get(self.text_panel):getComponent("Renderable")
		local bg = self.registry:get(self.bg_rect):getComponent("Renderable")
		local go = self.registry:get(self.gray_out):getComponent("Renderable")
		local yb = self.registry:get(self.start_btn):getComponent("Renderable")
		tp.text = "It is now " .. player.player_name .. "'s Turn!\n\nPress Start to Proceed, Sir"
		if self.byzantium_text then
			tp.text = "It is now " .. player.player_name .. "'s Turn!\n" .. self.byzantium_text .. "\n\n Press Start To Proceed, Sir"
		end
		if self.gameover_winner then
			tp.text = (self.gameover_winner == player.player_name) and self.gameover_winner_text or self.gameover_loser_text
		end
		tp.backgroundcolor = player.highlight_color
		yb.backgroundcolor = player.highlight_color
		bg.backgroundcolor = player.midtone_color
		go.backgroundcolor = player.shadow_color
		self.scenegraph:attach(self.root, attachTo)
		self.is_attached = true
	end
end

function TurnStartView:hide ()
	if self.is_attached then
		self.scenegraph:detach(self.root)
		self.is_attached = false
	end
end

return TurnStartView