local class = require 'lib/30log'
local IndexMap = class("IndexMap",{
	addressbook = {},
	placeables_index = {}
})

local Location = class("Location",{
	address = nil
	placeables = {},
	neighbors = {}
})

function Location:init(address, placeables, neighbors)
	if address == nil then error('Tried to create location with nil address') end
	self.address = address
	self.placeables = placeables or {}
	self.neighbors = neighbors or {}
end

function IndexMap:addNeighborsRelation(addressA, addressB)
	table.insert(self.addressbook[addressA],addressB)
	table.insert(self.addressbook[addressB],addressA)
end

function IndexMap:addAddress(address, neighborAddresses, placeableIds)
	self.addressbook[address] = Location:new(address, neighborAddresses, placeableIds)
end

function IndexMap:addPlaceable(placeableId, addressId)
	placeables_index[placeableId] = addressId
	self.addressbook[addressId].placeables[placeableId] = true
end

function IndexMap:removePlaceable(placeableId, addressId)
	if addressId == nil then 
		addressId = self:findPlaceableAddress(placeableId) 
	end
	if addressId ~= nil then 
		self.addressbook[addressId].placeables[placeableId] = nil 
	end
	placeables_index[placeableId] = nil
end

function IndexMap:getPlaceablesAt(addressId)
	local keyset={}
	local n=0

	for k,v in pairs(self.addressbook[addressId].placeables) do
	  n=n+1
	  keyset[n]=k
	end
	return keyset
end

function IndexMap:findPlaceableAddress(placeableId)
	return self.placeables_index[placeableId]
end

function IndexMap:hasPlaceable(placeableId, addressId)
	return self.placeables_index[placeableId] == addressId
end

function IndexMap:movePlaceable(placeableId, srcAddressId, dstAddressId)
	if self:hasPlaceable(srcAddressId, placeableId) then
		self:removePlaceable(placeableId, srcAddressId)
		self:addPlaceable(placeableId, dstAddressId)
	end
end


return IndexMap