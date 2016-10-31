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
	nid = nil
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
	if targetId == nil then targetId = self.nodes[1] end

	local parent = self:getParent(targetId)
	if parent == nil then 
		return targetId.nid 
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
	local newNode = Node:new(attacheeId)
	self.nodes[attacheeId] = newNode
	table.insert(self.nodes, newNode)

	if attachToId == nil then 
		print 'Warning: adding node to collection without a parent.'
	else
		local newEdge = Edge:new(attachToId, attacheeId)
		table.insert(self.edges, newEdge)
		table.insert(self.nodes[attachToId].children,attacheeId)
	end
end

function Collection:detach ( detachee )
	assert(detachee ~= nil, 'tried to detach nil')

	for i, v in ipairs(self.nodes) do
		if v.nid == detachee then
			table.remove(i)
			break
		end
	end

	for i, edge in ipairs(self.edges) do
		if edge.to == detachee or edge.from == detachee then
			if edge.from == detachee then
				print 'Warning: detaching from middle of tree'
			end
			table.remove(i)
			break
		end
	end
end

return Collection