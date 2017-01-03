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
	self.root = registry:make("tsv_root", {
		Transform:new(0,0)
	})
	self.scenegraph = scenegraph
	self.registry = registry

	local start_button_handler = TouchDelegate:new()
	local Block_Below_Delegate = TouchDelegate:new()

	start_button_handler:setHandler('onTouch', function(this, x, y)
		print("Let's go!")
		self:hide()
	end)
	local windowW = love.graphics:getWidth()
	local windowH = love.graphics:getHeight()
	local gray_out = registry:make("tsv_grayout", {
		Transform:new(0,0),
		Renderable:new(
			Polygon:new({w = windowW, h = windowH}),
			nil,
			{10,20,30,255}),
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
	local start_btnH = 40
	local bg_rect = registry:make("tsv_bg_rect", {
		Transform:new(panelX,panelY),
		Renderable:new(
			Polygon:new({w = panelW, h = panelH}),
			nil,
			{64, 128, 128,200}),
		})
	local text_panelH = panelH - 3 * margin - start_btnH
	local text_panel = registry:make("tsv_text_panel",{
		Transform:new(margin, margin),
		Renderable:new(
			Polygon:new({w = subPanelW, h = text_panelH}),
			nil,
			{100,200,200},
			"Your Turn")
		})
	local start_btnY = panelH - start_btnH - margin
	local start_btn = registry:make("tsv_confirm_btn",{
		Transform:new(margin, start_btnY),
		Renderable:new(
			Polygon:new({w = subPanelW, h = start_btnH}),
			nil,
			{100,200,200},
			"Begin"),
		Interfaceable:new(
			Polygon:new({w = 280, h = 40}),
			start_button_handler)
		})

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
		local tp = self.registry:get(self.text_panel, "Renderable")
		self.byzantium_text = "BYZANTIUM has been owned by " .. msg.player.player_name .. " for " .. msg.byzantium.turns_owned[msg.player.player_name] .." turns!\n They will win if they hold the throne for another " .. (5-msg.byzantium.turns_owned[msg.player.player_name]) .. "!"
	end)

	self.registry:subscribe("gameOverByzantiumWin", function(this, msg)
		local tp = self.registry:get(self.text_panel, "Renderable")
		self.gameover_winner = msg.player.player_name
		self.gameover_winner_text = "Congratulations, sir:\nBYZANTIUM has been held for 5 turns by " .. self.gameover_winner .. "!\n\nGAME WON, Sir!"
		self.gameover_loser_text = "I am sorry, but...\n" .. msg.player.player_name .. " has held BYZANTIUM for 5 turns!\n GAME OVER, Sir..."
		self.scenegraph:detach(self.start_btn)
	end)
end

function TurnStartView:show ( attachTo, player )
	if not self.is_attached then
		local tp = self.registry:get(self.text_panel, "Renderable")
		local bg = self.registry:get(self.bg_rect, "Renderable")
		local go = self.registry:get(self.gray_out, "Renderable")
		local yb = self.registry:get(self.start_btn, "Renderable")
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