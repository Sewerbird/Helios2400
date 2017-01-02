--GameInfo.lua
local Tserial = require 'lib/Tserial'
local Component = require 'src/Component'
local GameObject = require 'src/GameObject'

local GameInfo = Component:extend('GameInfo', {
	name = 'GameInfo',
	keys = {}
})

function GameInfo:init ( state )
	for key, value in pairs( state ) do
		self[key] = value
		table.insert(self.keys,key)
	end
end

function GameInfo:serialize ()
	local endo = {}
	for i, key in ipairs(self.keys) do
		endo[key] = self[key]
	end
	endo.gid = self.gid
	return Tserial.pack(endo)
end

function GameInfo:reify ( registry, string )
	local exo = Tserial.unpack(string,true)
	return registry:make(exo.description,{GameInfo:new(exo)})
end


return GameInfo