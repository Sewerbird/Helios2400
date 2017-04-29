local Connection = require "src/network/connection"
local HeliosConnection = {}
HeliosConnection.__index = HeliosConnection

local Text = require 'lib/LoveGUI/core/text'
local Container = require 'lib/LoveGUI/core/container'
local PlayerListItem = require 'src/ui/PlayerListItem'

local Lobby = require "src/gamestate/lobby"
local json = require "lib/json"

function HeliosConnection.new(address, port)
	nHC = {}
	setmetatable(nHC,HeliosConnection)
	nHC.connection = Connection.new(address, port, CLIENT_USERNAME, function(datagram) 
		HeliosConnection.onReceive(nHC,datagram)
	end)
	nHC:connect()
	return nHC
end

function HeliosConnection:update()
	self.connection:update()
end

function HeliosConnection:onReceive(datagram)
	local from, event, info = datagram:match("([^\t]*)\t([^\t]*)\t(.*)")
	if(from) then
		self:process(from,event,info)
	end
end

function HeliosConnection:connect()
	self.connection:send("CONNECT")
end

function HeliosConnection:ready(ready)
	self.connection:send("READY",ready)
end

function HeliosConnection:submitTurn()
	self.connection:send("SUBMIT","{gamestate: change_" .. (math.floor(math.random() * 10000)) .. "}")
end

function HeliosConnection:process(from,event,info)
	if event == "TURN" then
		locked = false
	elseif event == "LOBBY" then
		updateLobby(info)
	elseif event == "CHAT" then
		Global.Chat:add(from, info)
		updateChat()
	end
end

function HeliosConnection:chat(message)
	self.connection:send("CHAT",message)
end

function updateChat()
	local lobby = Global.Viewer.Systems.UIStack:peek()
	local chatBox = lobby:getElement('CHAT_BOX')
	if not chatBox then return end
	local chat = Global.Chat:readAsString(10)
	chatBox:setText(chat)
end

function updateLobby(game)
	local lobby = Global.Viewer.Systems.UIStack:peek()
	if lobby.id ~= 'LOBBY_CENTERING_HOR' then
		Global.Viewer.Systems.UIStack:pop()
		Global.Viewer.Systems.UIStack:push(Lobby)
		lobby = Lobby
	end
	game = json.decode(game)
	lobby:getElement('LOBBY_TITLE'):setText(game.lobbyName or "NA")
	local playerList = lobby:getElement('PLAYER_LIST')
	playerList:empty()
	local players = game.players
	for _,player in ipairs(players) do
		playerList:addElement(
			PlayerListItem(player.id,player.ready,"TEST_TEAM")
		)
	end
	updateChat()
end

return HeliosConnection