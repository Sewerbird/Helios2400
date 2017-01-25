local class = require 'lib/30log'
local ElementWrapper = class('ElementWrapper', {
	element = nil
})

function ElementWrapper:init (Element)
	self.element = element
end

function ElementWrapper:getElement()
	return self.element
end

function ElementWrapper:draw()
	self.element:draw()
end

return ElementWrapper
