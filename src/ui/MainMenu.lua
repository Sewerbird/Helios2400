local Container = require 'lib/LoveGUI/core/container'

local screenCover = Container.new('SCREEN_COVER',{
	alignment = 'center', 
	visible = false,
	ori = 'hor'
})

local centering_container = Container.new('MENU_CENTERING_CONTAINER',{
	width = '50%',
	alignment = 'center', 
	visible = false, 
	orientation = 'ver'
})
screenCover:addElement(centering_container)

local exit_menu = Container.new('MENU_CONTAINER',{
	height = '80%',
	alignment = 'top',
	orientation = 'ver'
})
centering_container:addElement(exit_menu)

return screenCover
