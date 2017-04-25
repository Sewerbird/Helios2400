local Text = require 'lib/LoveGUI/core/text'
local Container = require 'lib/LoveGUI/core/container'

local GrayScreen = Container.new('GRAY_SCREEN',{visible = true, ori = 'hor', alignment = 'center'})

local DialogTheme = require('src/theme/dialog')
GrayScreen:setTheme(DialogTheme)

local CenteringContainer = Container.new('DIALOG_CENTERING_CONTAINER',{width = '40%',alignment = 'top', visible = true, orientation = 'ver'})
GrayScreen:addElement(CenteringContainer)
local Options = Container.new('MENU_OPTIONS',{height = '70%',alignment = 'top', orientation = 'ver'})
CenteringContainer:addElement(Options)

local AddressText = Text.new('ADDRESS_TEXT',{height = 50, text = 'Enter the address of the\n game you wish to join'})
local Addressinput = Text.new('ADDRESS_INPUT',{text = 'address', height = 20})
Options:addElements({AddressText, AddressInput})

return GrayScreen