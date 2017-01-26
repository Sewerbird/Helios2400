local Element = require 'lib/LoveGUI/core/element'
local mapViewElement = Element.new('MAP_VIEW_ELEMENT',{
	width = '75%',
	height = '75%'
})
mapViewElement._draw = function(self)
	local x,y,w,h = self:getRectangle()
	love.graphics.stencil(function()
		love.graphics.rectangle('fill',x + 8,y + 8,w - 16,h - 16)
	end,'replace', 1)
   	love.graphics.setStencilTest("greater", 0)
	Global.Viewer.Systems.RS:draw()
   	love.graphics.setStencilTest()
   	love.graphics.setColor(0,0,256)
   	love.graphics.setLineWidth(3)
   	love.graphics.rectangle('line',x,y,w,h)
end

return mapViewElement