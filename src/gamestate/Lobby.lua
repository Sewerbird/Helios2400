local Text = require 'lib/LoveGUI/core/text'
local Input = require 'lib/LoveGUI/core/input'
local Button = require 'lib/LoveGUI/core/button'
local Element = require 'lib/LoveGUI/core/element'
local Container = require 'lib/LoveGUI/core/container'

local Lobby = Container.new('LOBBY',{width = '80%', ori = 'ver', alignment = 'center'})

local SciFiTheme = require('src/theme/scifi')
Lobby:setTheme(SciFiTheme)

local LobbyTitle = Text.new('LOBBY_TITLE',{text = 'LOBBY TITLE', height = 'wrap', font = love.graphics.newFont(24)})
local LobbyContainer = Container.new('LOBBY_CONTAINER')
Lobby:addElements({LobbyTitle,LobbyContainer})

local GameInfo = Container.new('GAME_INFO',{ori = 'ver'})
local LobbySettings = Container.new('LOBBY_SETTINGS',{width = '35%'})
LobbyContainer:addElements({GameInfo,LobbySettings})

local PlayerList = Container.new('PLAYER_LIST',{ori = 'ver'})
local ChatBox = Text.new('CHAT_BOX',{textLoc = 'bottomleft'})
local ChatContainer = Container.new('CHAT_CONTAINER', {height = 35})
local ReadyButton = Button.new('READY_BUTTON',{
	text = 'I\'m not Ready!', 
	width = 120, 
	height = 40, 
	font = love.graphics.newFont(18), 
	onRelease = function(self)
		self.on = not self.on
		print("TOGGLED",self.on and "true" or "false")
		Global.Connection:ready(self.on and "true" or "false")
		self:setText('I\'m ' .. (self.on and 'not' or '') .. ' Ready!')
	end
})
ReadyButton.on = false

local ChatInput = Input.new('CHAT_INPUT', {
	selected = true,
	onRelease = function(self)
		self:select()
	end, 
	onDone = function(self)
		submitChat()
	end}
)

function submitChat(message)
	Global.Connection:chat(ChatInput:getValue())
	ChatInput:setValue('')
end

local ChatSubmit = Button.new('CHAT_SUBMIT',{ width = 60, text = 'submit', onRelease = function (self)
	submitChat()
end})
ChatContainer:addElements({ChatInput,ChatSubmit})

GameInfo:addElements({PlayerList, ChatBox, ChatContainer, ReadyButton})

local lcHor = Container.new('LOBBY_CENTERING_HOR',{visible = false,alignment = 'center'})
lcHor:addElement(Lobby)

return lcHor