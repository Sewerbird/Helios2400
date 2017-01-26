local Container = require 'lib/LoveGUI/core/container'
local Text = require 'lib/LoveGUI/core/text'
local Button = require 'lib/LoveGUI/core/button'

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

local main_menu = Container.new('MENU_CONTAINER',{
	height = '80%',
	alignment = 'top',
	orientation = 'ver'
})
centering_container:addElement(main_menu)

main_menu:addElements({
	Container.new('TITLE_CENTER_HOR',{alignment = 'center', height = 'wrap', margins = 3, paddings = 3, visible = false}):addElement(
		Text.new('TITLE_TEXT_BOX',{width = 'wrap',height = 'wrap',alignment = 'center', text = 'HELIOS 2400 DEBUG MENU',margins = 3, paddings = 3})
	),
	Container.new('OPTIONS_CONTAINER',{orientation = 'ver', visible = false})
})

main_menu:getElement('OPTIONS_CONTAINER'):addElements({
	Button.new('SAVE_GAME_BUTTON',{margins = 30, orientation = 'hor', text = 'SAVE GAME', textLoc = 'center'}),
	Button.new('LOAD_GAME_BUTTON',{margins = 30, orientation = 'hor', text = 'SAVE GAME', textLoc = 'center'}),
	Button.new('QUIT_GAME_BUTTON',{text = 'Quit Game', margins = 30, textLoc = 'center'}),
	Button.new('RETURN_BUTTON',{text = 'Return ( or press Escape)', height = '30%', textLoc = 'center', topMargin = 20})
})

main_menu:getElement('MENU_CONTAINER'):addElement(Container.new('VIEW_CONTAINER',{height = '20%', visible = false}))
main_menu:getElement('VIEW_CONTAINER'):addElements({
	Button.new('PREVIOUS_VIEW_BUTTON',{text = 'Previous View', margins = 15}),
	Button.new('NEXT_VIEW_BUTTON'):setText('Next View'):setMargins(15)
})

main_menu:getElement('NEXT_VIEW_BUTTON').mousepressed = function(x, y)
	print("pressed NEXT_VIEW_BUTTON")
end

return screenCover
