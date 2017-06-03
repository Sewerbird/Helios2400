local Text = require 'lib/LoveGUI/core/text'
local Container = require 'lib/LoveGUI/core/container'
local PlayerListItem = require 'src/ui/PlayerListItem'

local Lobby = require "src/gamestate/lobby"
local json = require "lib/json"

function updateChat()
	local lobby = Global.Viewer.Systems.UIStack:peek()
	local chatBox = lobby:getElement('CHAT_BOX')
	if not chatBox then return end
	local chat = Global.Chat:readAsString(10)
	chatBox:setText(chat)
end

function handleChat(from,info)
	Global.Chat:add(from,info)
	updateChat()
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
	local address,port = Global.Connection.connection:getInfo()
	lobby:getElement('INFO_ADDRESS'):setText('Address: ' .. address)
	lobby:getElement('INFO_PORT'):setText('Port: ' .. port)

	updateChat()
end

function handleTurn(info)
	locked = false
end

return function(connection,from,event,info)
	if event == "TURN" then
		handleTurn()
	elseif event == "LOBBY" then
		updateLobby(info)
	elseif event == "CHAT" then
		handleChat(from, info)
	end
end