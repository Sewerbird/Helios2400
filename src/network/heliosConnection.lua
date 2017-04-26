local Connection = require "src/network/connection"
local HeliosConnection = {}
HeliosConnection.__index = HeliosConnection

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

function HeliosConnection:submitTurn()
	self.connection:send("SUBMIT","{gamestate: change_" .. (math.floor(math.random() * 10000)) .. "}")
end

function HeliosConnection:process(from,event,info)
	table.insert(messages,from.. ":\t" .. event .."\t" .. info)
	if event == "TURN" then
		locked = false
	end
end

return HeliosConnection