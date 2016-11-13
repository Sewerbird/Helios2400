local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Ring = class("Ring", {
	elements = {},
	cursor = nil
})

function Ring:init ( eles )
	if eles ~= nil then
		self:add(eles)
	end
end

function Ring:add (...)
	if ... then
		local targs = {...}
		for _,v in ipairs(targs) do
		  table.insert(self.elements, v)
		end
	end

  if self.cursor == nil then return self:next() end
  
  return view
end

function Ring:next ()
	if #(self.elements) == 0 then return nil end
	if cursor == nil then self.cursor = 0 end
	self.cursor = self.cursor + 1
	if self.cursor > #(self.elements) then self.cursor = 1 end
	return self.elements[self.cursor]
end

function Ring:current ()
	if self.cursor == nil then return self:next() end
	return self.elements[self.cursor]
end

function Ring:previous ()
	if #(self.elements) == 0 then return nil end
	if cursor == nil then self.cursor = 2 end
	self.cursor = self.cursor - 1
	if self.cursor == 0 then self.cursor = #(self.elements) end
	return self.elements[self.cursor]
end

return Ring