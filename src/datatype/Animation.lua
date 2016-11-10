--Animation.lua
local class = require 'lib/30log'
local Animation = class("Animation", {
	quad = nil,
	ani = nil,
	sprite = nil
})

function Animation:init (animation_reference, spriteSheet_reference )
	self.ani = animation_reference
	self.sprite = spriteSheet_reference
end

return Animation