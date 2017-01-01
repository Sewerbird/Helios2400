local Binding = class('Binding',{
	target = nil,
	component = nil,
	functor = nil
})

function Binding:init( gid, ctype, transformation )
	self.target = gid
	self.component = ctype
	self.functor = transformation
end

return Binding