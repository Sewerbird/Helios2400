local Theme = require('lib/LoveGUI/core/theme')
local theme = Theme.new()

local BACKGROUND_GRAY = {120,120,120,160}
local FOREGROUND_GRAY = {120,120,120,255}
local TEXT_BLACK = {20,20,20,255}

theme:set('container','onDraw',function(self)
	local x,y,w,h = self:getRectangle()

	love.graphics.setColor(BACKGROUND_GRAY)
	love.graphics.rectangle('fill', x, y, w, h)
	love.graphics.setColor(TEXT_BLACK)
	love.graphics.rectangle('line', x, y, w, h)
end)

theme:set('text','onDraw',function(self)
	local x,y,w,h = self:getRectangle()

	love.graphics.setColor(FOREGROUND_GRAY)
	love.graphics.rectangle('fill', x, y, w, h)
	
	love.graphics.setColor(TEXT_BLACK)
	local tx, ty = self:getTextLocation()
	love.graphics.setFont(self:getFont())
	love.graphics.print(self:getText(), tx,ty)
end)

return theme