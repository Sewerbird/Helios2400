local class = require 'lib/30log'
inspect = require 'lib/inspect'
local AStar = require 'src/structure/Astar'
local maphandler = require 'src/structure/MapHandler'

local IndexMap = class("IndexMap",{
	addressbook = {},
	placeables_index = {}
})

local Location = class("Location",{
	address = nil,
	placeables = {},
	neighbors = {},
	terrain_info = {}
})

function Location:init(address, x, y, neighbors, terrain_info)
	if address == nil then error('Tried to create location with nil address') end
	self.address = address
	self.placeables = {}
	self.neighbors = neighbors or {}
	self.terrain_info = terrain_info
	self.x = x
	self.y = y
end

function Location:__tostring()
	return "Location " .. self.address .. "(" .. self.x .. "," .. self.y .. ")[" .. #self.neighbors .. "]"
end

function IndexMap:getNeighbors(addressId)
	return self.addressbook[addressId].neighbors
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

function IndexMap:addAddress(address, x, y, neighborAddresses, terrainInfo, placeableIds)
	self.addressbook[address] = Location:new(address, x, y, neighborAddresses, terrainInfo, placeableIds)
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

function IndexMap:findPath(fromId, toId)
	return self.as:findPath(fromId,toId)
end

function IndexMap:summarizeAddress(addressId)
	return "Address '" .. addressId .. "' contains " .. inspect(self:getPlaceablesAt(addressId)) .. " and borders " .. inspect(self:getNeighbors(addressId))
end

function IndexMap:getLocation(x,y)
	return self.addressbook["AD" .. x .. y]
end

return IndexMap