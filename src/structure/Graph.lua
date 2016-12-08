--Graph.lua
local class = require 'lib/30log'
local inspect = require 'lib/inspect'

local Node = class('Node', {
	uid = nil,
	data = nil,
	inbound = {},
	outbound = {}
})

function Node:init(uid, data, children, parents)
	self.uid = uid
	self.data = data
end

function Node:addChild(uid)
	self.outbound[uid] = true
end

function Node:addParent(uid)
	self.inbound[uid] = true
end

local Graph = class('Graph', {
	nodes = nil,
	edges = nil,
	isCyclic = false,
	maxDepth = 100
})

function Graph:init ( nodes, edges, isCyclic )
	self.nodes = nodes or {}
	self.edges = edges or {}
	self.isCyclic = isCyclic or false

	for i, v in ipairs(self.nodes) do
		self:addNode(uid, v)
	end
	for i, v in ipairs(self.edges) do
		self:addEdge(v.src, v.tgt, v.obj)
	end
end

function Graph:addNode ( uid, obj )
	self.nodes[uid] = Node:new(uid, obj)
end

function Graph:hasNode ( uid )
	return self.nodes[uid] ~= nil
end

function Graph:addEdge ( src, tgt, obj )
	if not self.isCyclic and self:edgeWouldCauseCycle(src,tgt) then error('Adding cycle to graph! Offending edge is ' .. src .. '->' .. tgt) end
	self.nodes[src]:addChild(tgt)
	self.nodes[tgt]:addParent(src)
	self.edges[src .. tgt] = obj
end

function Graph:getChildren ( uid )
	return self.nodes[uid][outbound]
end

function Graph:getParents ( uid )
	return self.nodes[uid].inbound
end

function Graph:edgeWouldCauseCycle (src, tgt, iters)
	if iters == nil then iters = 0 end
	if iters > self.maxDepth then return true end
	if #(self.nodes[src].inbound) == 0 then return false end
	if self.nodes[src].inbound[tgt] then return true end
	for parent, _ in pairs(self.nodes[src].inbound) do
		if self:edgeWouldCauseCycle(parent, tgt, iters + 1) then return true end
	end
	return false
end

function Graph:getRoots( uid, tail )
	if tail == nil then tail = {} end
	if #(self.nodes[uid].inbound) == 0 then 
		tail[uid] = true 
		return tail
	end
	for parent, _ in pairs(self.nodes[src].inbound) do
		self:getRoots(parent, tail)
	end
	return tail
end

return Graph