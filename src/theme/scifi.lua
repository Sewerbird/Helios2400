local Theme = require('lib/LoveGUI/core/theme')
local theme = Theme.new()

local LIGHT_BLUE = {51,204,255}
local BLUE = {34,136,187}
local DARK_BLUE = {17,68,119}
local DARKER_BLUE = {0,0,51}

theme:set('container','onDraw',function(self)
	local x,y,w,h = self:getRectangle()

	love.graphics.setColor(BLUE)
	love.graphics.rectangle('fill', x, y, w, h)
	love.graphics.setColor(DARKER_BLUE)
	love.graphics.rectangle('line', x, y, w, h)
end)

theme:set('element','onDraw',function(self)
	local x,y,w,h = self:getRectangle()

	love.graphics.setColor(BLUE)
	love.graphics.rectangle('fill', x, y, w, h)
	love.graphics.setColor(DARKER_BLUE)
	love.graphics.rectangle('line', x, y, w, h)
end)

theme:set('dropdown','onDraw',function(self)
	local x,y,w,h = self:getRectangle()

	love.graphics.setColor(BLUE)
	love.graphics.rectangle('fill', x, y, w, h)
	love.graphics.setColor(DARKER_BLUE)
	love.graphics.rectangle('line', x, y, w, h)
end)

theme:set('text','onDraw',function(self)
	local x,y,w,h = self:getRectangle()

	love.graphics.setColor(DARK_BLUE)
	love.graphics.rectangle('fill', x, y, w, h)
	love.graphics.setColor(DARKER_BLUE)
	love.graphics.rectangle('line', x, y, w, h)
	
	love.graphics.setColor(LIGHT_BLUE)
	local tx, ty = self:getTextLocation()
	love.graphics.setFont(self:getFont())
	love.graphics.print(self:getText(), tx,ty)
end)

return theme