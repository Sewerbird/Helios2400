local Element = require 'lib/LoveGUI/core/element'
local MainMenuElement = require 'src/ui/MainMenuElement'
local GameObject = require 'src/GameObject'
local ElementWrapper = require 'src/component/ElementWrapper'

local mapView = {}

function mapView.new()
	local mapViewElement = Element.new('MAP_VIEW_ELEMENT',{
		width = '100%',
		height = '90%'
	})
	mapViewElement._draw = function(self)
		local x,y,w,h = self:getRectangle()
		love.graphics.stencil(function()
			love.graphics.rectangle('fill',x,y,w,h)
		end,'replace', 1)
	   	love.graphics.setStencilTest("greater", 0)
		Global.Viewer.Systems.Render:draw()
	   	love.graphics.setStencilTest()
	   	love.graphics.setColor(0,0,256)
	   	love.graphics.setLineWidth(3)
	   	love.graphics.rectangle('line',x,y,w,h)
	end

	mapViewElement.mousepressed = function(self, x, y)
		print("mouse pressed on map",x ,y)
		--TODO offset the x, y
		Global.Viewer.Systems.Interface:onTouch(x,y)
	end

	mapViewElement.mousereleased = function(self, x, y)
		print("mouse released on map",x ,y)
		--TODO offset the x, y
		Global.Viewer.Systems.Interface:onUntouch(x,y)
	end

	mapViewElement.keypressed = function(self, key, focus)
		if key == 'n' then
	    	Global.Viewer:nextView()
		elseif key == 'q' then
			Global.Viewer.Registry:publish("endTurn")
		elseif key == 'm' then
			local mm = MainMenuElement.new()
			local menuViewObject = GameObject:new('MAIN_MENU',{
				ElementWrapper:new(mm)
			},Global.Registry)
			Global.Viewer.Systems.UIStack:push(mm)
		end
		Global.Viewer.Systems.Interface:onKeypress(key)
	end

	mapViewElement.mousedragged = function(self, x,y,dx,dy)
    	Global.Viewer.Systems.Interface:onDrag(x,y,dx,dy)
    end
    
	return mapViewElement
end

return mapView
