--Collection.lua
local Collection = class("Collection", {
	edges = {},
	nodes = {}
})

local Edge = class("Edge", {
	to = nil,
	from = nil
})
function Edge:init ( from, to )
	self.to = to
	self.from = from
end

local Node = class("Node", {
	nid = nil,
	children = {}
})
function Node:init ( nid )
	self.nid = nid
	self.children = {}
end

function Collection:init ()

end

function Collection:getRoot ( targetId )
	--TODO: Only works if collection is a singleton tree
	assert(#self.nodes > 0, 'no nodes in tree to be a root')

	if #self.nodes == 0 then return nil end
	if targetId == nil then 
		for i, v in pairs(self.nodes) do
			targetId = v.nid 
			break
		end
	end
	local parent = self:getParent(targetId)
	if parent == nil then 
		return targetId
	else 
		return self:getRoot(parent) 
	end
end

function Collection:getParent ( targetId )
	for i, edge in ipairs(self.edges) do
		if edge.to == targetId then
			return edge.from
		end
	end
	return nil
end

function Collection:getParents ( targetId )
	local parents = {}
	for i, edge in ipairs(self.edges) do
		if edge.to == targetId then
			table.insert(parents, edge.from)
		end
	end
	return parents
end

function Collection:getChildren ( targetId )
	return self.nodes[targetId].children
end

function Collection:hasChildren ( targetId )
	return #self.nodes[targetId].children > 0
end

function Collection:attachAll( attacheeArray, attachToId )
	for i, attachee in ipairs(attacheeArray) do
		self:attach(attachee, attachToId)
	end
end

function Collection:attach ( attacheeId, attachToId )
	assert(attacheeId ~= nil, 'trid to attach nil')
	if self.nodes[attacheeId] == nil then
		local newNode = Node:new(attacheeId)
		self.nodes[attacheeId] = newNode
	end

	if attachToId == nil then 
		print 'Warning: adding node to collection without a parent.'
	else
		local newEdge = Edge:new(attachToId, attacheeId)
		table.insert(self.edges, newEdge)
		table.insert(self.nodes[attachToId].children,attacheeId)
	end
end

function Collection:detach ( detachee, detachFromId )
	assert(detachee ~= nil, 'tried to detach nil')

	for i, edge in ipairs(self.edges) do
		if edge.to == detachee then
			for j, child in ipairs(self.nodes[edge.from].children) do
				if child == detachee then
					table.remove(self.nodes[edge.from].children, j)
					break
				end
			end
			table.remove(self.edges, i)
			break
		end
	end
end

return Collection