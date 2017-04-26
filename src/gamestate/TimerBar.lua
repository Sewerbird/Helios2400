local Container = require 'lib/LoveGUI/core/container'
local Text = require 'lib/LoveGUI/core/text'
local Button = require 'lib/LoveGUI/core/button'

local TimerBar = {}

function TimerBar.new()
	local base = Container.new('TIMER_BASE',{
		visible = true,
		alignment = 'right',
		ori = 'hor',
		width = '100%',
		height = '20%',
		paddings = 0,
		margins = 0
	}):addElement(
		Container.new('COUNTDOWN_PANEL',{
			visible = true,
			width = 100,
			alignment = 'right',
			ori = 'ver',
			paddings = 0,
			margins = 0
		}):addElements({
			Button.new("READY_BUTTON", { 
				margins = 0, 
				paddings = 0, 
				orientation = 'hor', 
				text = 'READY', 
				textLoc = 'center'
			}),
			Container.new("COUNTDOWN_TIMER_PANEL", { 
				margins = 0,
				paddings = 0, 
				orientation = 'hor'
			}):addElement(
				Text.new("COUNTDOWN_TIMER_TEXT", {
					width = '100%', 
					height = '100%', 
					alignment = 'center', 
					text = '00:30s', 
					margins = 0, 
					paddings = 0
			}))
		})
	)

	return base
end

return TimerBar
