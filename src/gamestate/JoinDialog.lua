local Text = require 'lib/LoveGUI/core/text'
local Input = require 'lib/LoveGUI/core/input'
local Container = require 'lib/LoveGUI/core/container'

local GrayScreen = Container.new('GRAY_SCREEN',{visible = true, ori = 'hor', alignment = 'center'})

local DialogTheme = require('src/theme/dialog')
GrayScreen:setTheme(DialogTheme)

local CenteringContainer = Container.new('DIALOG_CENTERING_CONTAINER',{width = '40%',alignment = 'top', visible = true, orientation = 'ver'})
GrayScreen:addElement(CenteringContainer)
local Options = Container.new('MENU_OPTIONS',{height = '70%',alignment = 'top', orientation = 'ver'})
CenteringContainer:addElement(Options)

local AddressText = Text.new('ADDRESS_TEXT',{height = 50, text = 'Enter the address of the\n game you wish to join'})
local Addressinput = Input.new('ADDRESS_INPUT',{default = 'localhost:50000', height = 20, selected = false})
Addressinput:setOnRelease(function(self)
	self:select()
end)

Options:addElements({AddressText, Addressinput})

return GrayScreen