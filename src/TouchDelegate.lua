--TouchDelegate.lua
local TouchDelegate = class("TouchDelegate", {
	handlers = {}
})

function TouchDelegate:init ( absorbsClicks )

end

function TouchDelegate:setHandler ( event, handler )
	self.handlers[event] = handler
end

function TouchDelegate:hasHandler ( event )
	return self.handlers[event] ~= nil
end

function TouchDelegate:onTouch ( x, y )
	if self:hasHandler('onTouch') then
		self.handlers['onTouch'](self,x, y )
	end
end

function TouchDelegate:onDrag ( x, y, dx, dy)
	if self:hasHandler('onDrag') then
		self.handlers['onDrag'](self,x,y,dx,dy)
	end
end

function TouchDelegate:onHover ( x, y)
	if self:hasHandler('onHover') then
		self.handlers['onHover'](self,x,y)
	end
end

function TouchDelegate:onUntouch ( x, y )
	if self:hasHandler('onUntouch') then
		self.handlers['onUntouch'](self,x,y)
	end
end

function TouchDelegate:onKeypress ( key )
	if self:hasHandler('onKeypress') then
		self.handlers['onKeypress'](self,key)
	end
end

return TouchDelegate