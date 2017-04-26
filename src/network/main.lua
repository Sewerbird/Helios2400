local HeliosConnection = require "./heliosConnection"
messages = {}

function love.load()
	connection = HeliosConnection.new()
end

locked = false

function love.update(dt)
	connection:update(dt)
	if not locked and math.random() > 0.995 then
		connection:submitTurn()
		locked = true
	end
end

MAX_MESSAGES = 10

function love.draw()
	text = ""
	i = #messages
	while (i > #messages - MAX_MESSAGES and i > 0) do
    	text = messages[i] .. "\n" .. text
    	i = i - 1
    end
    love.graphics.print("Messages:\n" .. text, 16, 16)
end