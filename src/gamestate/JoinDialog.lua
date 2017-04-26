local Text = require 'lib/LoveGUI/core/text'
local Input = require 'lib/LoveGUI/core/input'
local Button = require 'lib/LoveGUI/core/button'
local Container = require 'lib/LoveGUI/core/container'

local HeliosConnection = require "src/network/heliosConnection"

local GrayScreen = Container.new('GRAY_SCREEN',{visible = true, ori = 'hor', alignment = 'center'})

local DialogTheme = require('src/theme/dialog')
GrayScreen:setTheme(DialogTheme)

local CenteringContainer = Container.new('DIALOG_CENTERING_CONTAINER',{width = '40%',alignment = 'top', visible = true, orientation = 'ver'})
GrayScreen:addElement(CenteringContainer)
local Options = Container.new('MENU_OPTIONS',{height = '70%',alignment = 'top', orientation = 'ver'})
CenteringContainer:addElement(Options)

local AddressText = Text.new('ADDRESS_TEXT',{height = 50, text = 'Enter the address of the\n game you wish to join'})
local Addressinput = Input.new('ADDRESS_INPUT',{default = 'localhost:50000', height = 20, selected = false, onRelease = function(self)
	self:select()
end})
local JoinButton = Button.new('CONNECT_BUTTON',{height = 40, text = 'Connect', onRelease = function (self)
	print("Send server CONNECT message here")
	self.parent:getElement('INFO_TEXT'):setText('Connecting to ' .. Addressinput:getValue())

	Global.Connection = HeliosConnection.new('localhost',50000)

end})
local Info = Text.new('INFO_TEXT', {height = 50, text = '-'})
local CancelButton = Button.new('CANCEL_BUTTON',{height = 40, text = 'Cancel', onRelease = function (self)
	Global.Viewer.Systems.UIStack:pop()
end})

Options:addElements({AddressText, Addressinput, JoinButton, Info, CancelButton})

return GrayScreen