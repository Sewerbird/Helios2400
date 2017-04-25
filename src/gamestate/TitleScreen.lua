local Container = require 'lib/LoveGUI/core/container'
local Button = require 'lib/LoveGUI/core/button'
local Text = require 'lib/LoveGUI/core/text'

local TitleScreen = Container.new('FULL_WINDOW',{visible = false, ori = 'hor', alignment = 'center'})

TitleScreen:addElement(
    Container.new('MENU_CENTERING_CONTAINER',{width = '35%',alignment = 'center', visible = false, orientation = 'ver'}):addElement(
        Container.new('MENU_OPTIONS',{height = '70%',alignment = 'top', orientation = 'ver'})
    )
)

TitleScreen:getElement('MENU_OPTIONS'):addElements({
    Text.new('TITLE_TEXT',{textLoc = 'center',text = 'Helios 2400', height = 50}),
    Button.new('JOIN_GAME',{margins = 20, height = '8%', text = 'Join a Game', onRelease = function(self)
        Global.Viewer.Systems.UIStack:pop()
        Global.Viewer.Systems.UIStack:push(Global.Viewer.game.GameWrapper)
    end}),
    Button.new('EXIT_GAME',{margins = 20, height = '8%', text = 'Exit Helios', onRelease = function(self)
        love.event.quit()
    end})
})

return TitleScreen