--TouchDelegate.lua
local TouchDelegate = class("TouchDelegate", {
	handlers = {},
	component = nil
})

function TouchDelegate:init ( )

end

function TouchDelegate:setHandler ( event, handler )
	self.handlers[event] = handler
end

function TouchDelegate:hasHandler ( event )
	return self.handlers[event] ~= nil
end

function TouchDelegate:onTouch ( x, y )
	if self:hasHandler('onTouch') then
		return self.handlers['onTouch'](self,x, y )
	end
	return false;
end

function TouchDelegate:onDrag ( x, y, dx, dy)
	if self:hasHandler('onDrag') then
		return self.handlers['onDrag'](self,x,y,dx,dy)
	end
	return false;
end

function TouchDelegate:onHover ( x, y)
	if self:hasHandler('onHover') then
		return self.handlers['onHover'](self,x,y)
	end
	return false;
end

function TouchDelegate:onUntouch ( x, y )
	if self:hasHandler('onUntouch') then
		return self.handlers['onUntouch'](self,x,y)
	end
	return false;
end

function TouchDelegate:onKeypress ( x, y, dx, dy, key )
	if self:hasHandler('onKeypress') then
		return self.handlers['onKeypress'](self,key)
	end
	return false;
end

return TouchDelegate