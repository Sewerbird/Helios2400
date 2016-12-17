--IndexTree.lua
local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local IndexTree = class("IndexTree", {
	nodes = {},
	root = nil
})

local Node = class("Node", {
	nid = nil,
	children = {}
})
function Node:init ( nid )
	self.nid = nid
	self.children = {}
	self.parents = {}
end

function IndexTree:init ()
end

function IndexTree:setRoot ( nid )
	self.root = nid
end

function IndexTree:getRoot ( targetId )
	if self.root then return self.root end
	--TODO: Only works if IndexTree is a singleton tree

	--assert(#self.nodes > 0, 'no nodes in tree to be a root')
	--if #self.nodes == 0 then return nil end
	if targetId == nil then 
		for i, v in pairs(self.nodes) do
			if self.nodes[v.nid] ~= nil then
				targetId = v.nid
				break
			end
		end
	end

	local parent = self:getParent(targetId)
	if parent == nil then 
		return targetId
	else 
		return self:getRoot(parent) 
	end
end

function IndexTree:getParent ( targetId )
	if #self.nodes[targetId].parents > 0 then
		return self.nodes[targetId].parents[1]
	else
		return nil
	end
end

function IndexTree:has (targetId)
	return self.nodes[targetId]
end

function IndexTree:getParents ( targetId )
	return self.nodes[targetId].parents
end

function IndexTree:getChildren ( targetId )
	return self.nodes[targetId].children
end

function IndexTree:hasChildren ( targetId )
	return #self.nodes[targetId].children > 0
end

function IndexTree:attachAll( attacheeArray, attachToId )
	for i, attachee in ipairs(attacheeArray) do
		self:attach(attachee, attachToId)
	end
end

function IndexTree:attach ( attacheeId, attachToId )
	assert(attacheeId ~= nil, 'tried to attach nil' .. tostring(attachToId))
	if self.nodes[attacheeId] == nil then
		local newNode = Node:new(attacheeId)
		self.nodes[attacheeId] = newNode
	end

	if attachToId ~= nil then 
		table.insert(self.nodes[attacheeId].parents,attachToId)
		table.insert(self.nodes[attachToId].children,attacheeId)
	end
end

function IndexTree:detachAll ( detachFromId )
	local v = self.nodes[detachFromId]
	for j, p in ipairs(v.children) do
		for k, c in ipairs(self.nodes[p].parents) do
			if c == v.nid then
				table.remove(self.nodes[p].parents, k)
			end
		end
	end
	v.children = {}
end

function IndexTree:detach ( detachee, detachFromId )
	assert(detachee ~= nil, 'tried to detach nil')
	local v = self.nodes[detachee]
	if not v then
		error("Detachee " .. detachee .. " not in index tree")
	else
		for j, p in ipairs(v.parents) do
			for k, c in ipairs(self.nodes[p].children) do
				if c == v.nid then
					table.remove(self.nodes[p].children, k)
					break
				end
			end
		end
		v.parents = {}
	end
end

function IndexTree:printIndexTree ()
	for i, node in pairs(self.nodes) do
		local s = "\t"..node.nid..":{"
		for q, v in ipairs(node.children) do
			s = s ..",".. v
		end
		s = s .. "}"
		print(s)
	end
end

return IndexTree