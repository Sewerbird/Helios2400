--System.lua
local System = class("System",{
	componentPool = {},
	rootGameObject = nil
})

function System:addComponent ( component )
	componentPool[component.gid] = component
end

function System:removeComponentByGameObjectId ( component_gid )
	componentPool[component.gid] = nil
end

function System:depthFirstEvalLeavesFirst ( func, obj )
	for i, ele in ipairs(obj:getChildren()) do
		self:depthFirstEvalLeavesFirst(func, ele)
		func(ele)
	end
	func(obj)
end

function System:depthFirstEvalRootFirst ( func, obj )
	func(obj)
	for i, ele in ipairs(obj:getChildren()) do
		func(ele)
		self:depthFirstEvalRootFirst(func, ele)
	end
end

return System