local Chat = {}
Chat.__index = Chat

function Chat.new()
	local nChat = {
		messages = {}
	}
	setmetatable(nChat,Chat)
	return nChat
end

function Chat:add(from, msg)
	table.insert(self.messages,{from, msg})
end

function Chat:read(lastX)
	local res = {}
	for i=1,lastX do
		if not self.messages[i] then return res end
		table.insert(res,self.messages[i])
	end
	return res
end

function Chat:readAsString(lastX)
	local res = ""
	for _,msg in ipairs(self:read(lastX)) do
		res = res .. msg[1] .. ": " .. msg[2] .. "\n"
	end
	return res
end

return Chat