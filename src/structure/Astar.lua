local class = require 'lib/30log'
local Astar = class('Astar',{
	indexMap = nil
})

COST_ESTIMATE = 1

function Astar:init(indexMap)
	self.indexMap = indexMap
end

function Astar:findPath(fromAddress, toAddress, moveType)
	-- The set of nodes already evaluated.
	local closed = {}
	-- The set of currently discovered nodes still to be evaluated.
	-- Initially, only the start node is known.
	local open = {fromAddress}
	-- For each node, which node it can most efficiently be reached from.
    -- If a node can be reached from many nodes, cameFrom will eventually contain the
    -- most efficient previous step.
    local cameFrom = {}

    -- For each node, the cost of getting from the start node to that node.
    local gScore = {}
    -- The cost of going from start to start is zero.
    gScore[fromAddress] = 0
    -- For each node, the total cost of getting from the start node to the goal
    -- by passing by that node. That value is partly known, partly heuristic.
    local fScore = {}
    fScore[fromAddress] = COST_ESTIMATE

    while (#open > 0) do
    	-- the node in openSet having the lowest fScore[] value
    	local currentAddress = self.lowestFscore(fScore,open)
    	if (currentAddress == toAddress) then
    		currentAddress = cameFrom[toAddress]
    		local path = {toAddress}
    		while not(currentAddress == nil) do
    			table.insert(path,currentAddress)
    			currentAddress = cameFrom[currentAddress]
    		end
    		return path, gScore[toAddress]
    	end

    	table.insert(closed,currentAddress)
    	for i,v in ipairs(open) do
    		if (v == currentAddress) then
    			table.remove(open,i)
    		end
    	end
    	local neighbors = self:getNeighbors(currentAddress)
    	for i,neighbor in ipairs(neighbors) do
    		if not tableContains(closed,neighbor) then
	    		local distStartNeighbor = gScore[currentAddress] + self:moveDifficult(neighbor,moveType)
	    		if not tableContains(open,neighbor) then
	    			table.insert(open,neighbor)
		    		cameFrom[neighbor] = currentAddress
	    			fScore[neighbor] = math.huge
	    			gScore[neighbor] = math.huge
	    		elseif not (distStartNeighbor > gScore[neighbor]) then
		    		cameFrom[neighbor] = currentAddress
		    		gScore[neighbor] = distStartNeighbor
		    		fScore[neighbor] = gScore[neighbor] + COST_ESTIMATE
		    	end
	    	end
    	end
    end

    return nil

end

function tableContains(table, element)
	for i,v in ipairs(table) do
		if v == element then return true end
	end
	return false
end

function Astar:getNeighbors(address)
	return self.indexMap:getNeighbors(address) or {}
end

function Astar:moveDifficult(address,moveType)
	return self.indexMap:getTerrainInfo(address)[moveType or "land"]
end

function Astar.lowestFscore(fScore,within)
	local lowest = nil
	for k,v in pairs(within) do
		if lowest == nil then lowest = v 
		elseif fScore[v] < fScore[lowest] then lowest = v end
	end
	return lowest
end

return Astar
