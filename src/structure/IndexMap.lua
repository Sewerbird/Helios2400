local class = require 'lib/30log'
inspect = require 'lib/inspect'
local AStar = require 'src/structure/Astar'

local IndexMap = class("IndexMap",{
	addressbook = {},
	placeables_index = {},
	map_name = nil
})

local Location = class("Location",{
	address = nil,
	placeables = {},
	neighbors = {},
	terrain_info = {}
})

function Location:init(address, neighbors, terrain_info)
	if address == nil then error('Tried to create location with nil address') end
	self.address = address
	self.placeables = {}
	self.terrain_info = terrain_info
	self.neighbors = neighbors or {}
end

function Location:__tostring()
	return "Location " .. self.address .. "[" .. #self.neighbors .. "]"
end

function IndexMap:load(registry, map)
	local hexes = {}
	local armies = {}
	local cities = {}
	self.map_name = map
	
	for id, tgt in ipairs(registry:findAll("GameInfo")) do
		if tgt.gs_type == "tile" and tgt.map == map then
			table.insert(hexes, tgt)
		elseif tgt.gs_type == "city" and tgt.map == map then
			table.insert(cities, tgt)
		elseif tgt.gs_type == "army" and tgt.map == map then
			table.insert(armies, tgt)
		end
	end

	for i, hex in ipairs(hexes) do
		local my_cities = {}
		local my_armies = {}
		self:addAddress(hex.address, hex.neighbors,hex.terrain_info)
		for j, city in ipairs(cities) do
			if city.address == hex.address then
				self:addPlaceable(city.gid, hex.address)
			end
		end
		for j, army in ipairs(armies) do
			if army.address == hex.address then
				self:addPlaceable(army.gid, hex.address)
			end
		end
	end
end

function IndexMap:getNeighbors(addressId)
	if self.addressbook[addressId] then return self.addressbook[addressId].neighbors end
end	

function IndexMap:getTerrainInfo(addressId)
	return self.addressbook[addressId].terrain_info
end

function IndexMap:init()
	self.as = AStar(self)
end

function IndexMap:addNeighborsRelation(addressA, addressB)
	table.insert(self.addressbook[addressA].neighbors,addressB)
	table.insert(self.addressbook[addressB].neighbors,addressA)
end

function IndexMap:addAddress(address, neighborAddresses, terrainInfo, placeableIds)
	self.addressbook[address] = Location:new(address, neighborAddresses, terrainInfo, placeableIds)
	if placeableIds ~= nil then
		for i = 1, #placeableIds do
			if placeableIds[i] ~= nil then self:addPlaceable(placeableIds[i],address) end
		end
	end
end

function IndexMap:addPlaceable(placeableId, addressId)
	self.placeables_index[placeableId] = addressId
	table.insert(self.addressbook[addressId].placeables, placeableId)
end

function IndexMap:removePlaceable(placeableId, addressId)
	if addressId == nil then 
		addressId = self:findPlaceableAddress(placeableId) 
	end
	if addressId ~= nil then 
		for i, v in ipairs(self.addressbook[addressId].placeables) do
			if v == placeableId then
				table.remove(self.addressbook[addressId].placeables, i)
				break
			end
		end
	end
	self.placeables_index[placeableId] = nil
end

function IndexMap:getPlaceablesAt(addressId)
	return self.addressbook[addressId].placeables
end

function IndexMap:findPlaceableAddress(placeableId)
	return self.placeables_index[placeableId]
end

function IndexMap:hasPlaceable(addressId, placeableId)
	return self.placeables_index[placeableId] == addressId
end

function IndexMap:movePlaceable(placeableId, srcAddressId, dstAddressId)
	if self:hasPlaceable(srcAddressId, placeableId) == true then
		self:removePlaceable(placeableId, srcAddressId)
		self:addPlaceable(placeableId, dstAddressId)
	end
end

function IndexMap:findPath(fromId, toId, moveType)
	local path, total_cost, costs = self.as:findPath(fromId, toId, moveType)
	return path, total_cost, costs
end

function IndexMap:findAccessibleAddresses(fromId, maxCost, moveType)
	local result = {}
	result[fromId] = 1
	for i,neighbor in ipairs(self.addressbook[fromId].neighbors) do
		local moveCost = self.addressbook[neighbor].terrain_info[moveType or "land"]
		if  moveCost <= maxCost then
			local toAdd = self:findAccessibleAddresses(neighbor, maxCost - moveCost, moveType)
			for k,v in pairs(toAdd) do
				result[k] = 1
			end
		end
	end

	local returnResult = {}
	for k,v in pairs(result) do
		table.insert(returnResult,k)
	end

	return result
end

function IndexMap:summarizeAddress(addressId)
	return "Address '" .. addressId .. "' contains " .. inspect(self:getPlaceablesAt(addressId)) .. " and borders " .. inspect(self:getNeighbors(addressId))
end

return IndexMap