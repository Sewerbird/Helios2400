local Text = require 'lib/LoveGUI/core/text'
local Container = require 'lib/LoveGUI/core/container'

local GrayScreen = Container.new('GRAY_SCREEN',{visible = true, ori = 'hor', alignment = 'center'})

local AddressText = Container.new('MENU_CENTERING_CONTAINER',{width = '30%',alignment = 'center', visible = true, orientation = 'ver'}):addElement(
    Container.new('MENU_OPTIONS',{height = '70%',alignment = 'top', orientation = 'ver'})
)

GrayScreen:addElement(AddressText)

return GrayScreen