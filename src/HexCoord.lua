local class = require 'lib/30log'
local HexCoord = class('HexCoord',{
	
})

function HexCoord:init ( column, row )
	self.row = row
	self.column = column
end

function HexCoord:toString ()
	return self.column .. "_" .. self.row
end

return HexCoord