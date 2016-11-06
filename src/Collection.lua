--Collection.lua
local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Collection = class("Collection", {
	nodes = {}
})

local Node = class("Node", {
	nid = nil
})
function Node:init ( nid )
	self.nid = nid
	self.children = {}
	self.parents = {}
end

function Collection:init ()

end

function Collection:getRoot ( targetId )
	--TODO: Only works if collection is a singleton tree
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

function Collection:getParent ( targetId )
	if #self.nodes[targetId].parents > 0 then
		return self.nodes[targetId].parents[1]
	else
		return nil
	end
end

function Collection:getParents ( targetId )
	return self.nodes[targetId].parents
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

function Collection:detach ( detachee )
	assert(detachee ~= nil, 'tried to detach nil')

	v = self.nodes[detachee]
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

function Collection:printCollection ()
	for i, node in pairs(self.nodes) do
		local s = "\t"..node.nid..":{"
		for q, v in ipairs(node.children) do
			s = s ..",".. v
		end
		s = s .. "}"
		print(s)
	end
end

return Collection