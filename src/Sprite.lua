--Sprite.lua
local Sprite = class("Sprite", {
	quad = nil,
	img = nil
})

function Sprite:init ( img_reference, quad_reference )
	self.img = img_reference
	self.quad = quad_reference
end

return Sprite