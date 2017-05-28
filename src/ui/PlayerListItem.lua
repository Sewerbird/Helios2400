local Dropdown = require 'lib/LoveGUI/core/dropdown'
local Container = require 'lib/LoveGUI/core/container'

local LIGHT_BLUE = {51,204,255}
local BLUE = {34,136,187}
local DARK_BLUE = {17,68,119}

return function(id, ready, team)
	local elem = Container.new('PLAYER_LIST_ITEM_' .. id,{
		height = 40,
		alignment = 'right',
		ori = 'hor',
		customDraw = function(self)
			local x,y,w,h = self:getRectangle()

			love.graphics.setColor(LIGHT_BLUE)
			love.graphics.rectangle('fill', x, y, w, h, 5, 5)
			love.graphics.setColor(DARK_BLUE)
			love.graphics.rectangle('line', x, y, w, h, 5, 5)

			love.graphics.setColor(ready and {0,200,0} or {200,0,0})
			love.graphics.setLineWidth(1)
			love.graphics.circle('fill',x + 20,y + 20, 16)
			love.graphics.setColor(BLUE)
			love.graphics.setLineWidth(3)
			love.graphics.circle('line',x + 20,y + 20, 16)

			love.graphics.setColor(DARK_BLUE)
			love.graphics.setFont(love.graphics.newFont(16))
			love.graphics.print(id, x + 40,y + 10)
		end}
	)

	local teamColor = Dropdown.new('TEAM_COLOR_' .. id,{
		height = 30,
		width = 40
	})

	elem:addElement(teamColor)

	return elem
end