--TouchDelegate.lua
local TouchDelegate = class("TouchDelegate", {
	absorbsClicks = false
})

function TouchDelegate:init ( absorbsClicks )
	
end

function TouchDelegate:onTouch ( x, y )
	print('Touched!')
end

function TouchDelegate:onDrag ( x, y, dx, dy)
	print('Dragged!')
end

function TouchDelegate:onHover ( x, y)
	print('Hovered!')
end

function TouchDelegate:onUntouch ( x, y )
	print('Untouched!')
end

function TouchDelegate:onKeypress ( key )
	print('Pressed!' .. key)
end

return TouchDelegate