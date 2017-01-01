--PlayerInfo.lua
local Tserial = require 'lib/Tserial'
local GameInfo = require 'src/component/GameInfo'

local PlayerInfo = GameInfo:extend('PlayerInfo', {
	name = 'PlayerInfo',
	keys = {}
})

function PlayerInfo:init ( state )
	PlayerInfo.super.init(self, state)
end

return PlayerInfo