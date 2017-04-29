local socket = require "socket"

local Connection = {}
Connection.__index = Connection

function Connection.new(address, port, id, onReceive)
	local nConnection = {}
	setmetatable(nConnection,Connection)
	math.randomseed(os.time())
	nConnection.id = id or math.random(1000,10000)
	nConnection.tcp = assert(socket.tcp())
	nConnection.tcp:connect(address, port)
	nConnection.tcp:settimeout(0)
	nConnection.onReceive = onReceive
	return nConnection
end

function Connection:send(event, info)
	print("sending",self.id)
	return self.tcp:send(self.id .."\t" .. event .. "\t" .. (info or "") .. "\n")
end

function Connection:update()
	local res = self.tcp:receive()
	if res then
		self.onReceive(res)
	end
end

function Connection.onReceive(datagram)
	print("no onReceive function defined.")
end

function Connection:getInfo()
	local a,b = self.tcp:getsockname()
	return self.tcp:getsockname()
end

return Connection