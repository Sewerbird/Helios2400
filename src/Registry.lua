--Registry.lua
local class = require 'lib/30log'
local Tserial = require 'lib/Tserial'
local GameObject = require 'src/GameObject'
local GameInfo = require 'src/component/GameInfo'
local PubSub = require 'src/PubSub'
local Graph = require 'src/structure/Graph'
local UUID = require 'lib/uuid'

local Registry = class('Registry', {
	bind_graph = nil,
	registry = {},
	pubsub = nil,
	historicCounter = 0
})

function Registry:init ( )
	self.pubsub = PubSub:new()
	self.bind_graph = Graph:new()
end

function Registry:add ( tgtObject )
	assert(tgtObject ~= nil, 'tgtObject being registered is nil')

	tgtObject.uid = self.historicCounter + 1
	tgtObject.registry = self
	self.historicCounter = self.historicCounter + 1

	if self.registry[tgtObject.uid] ~= nil then
		error('Registry object with uid already exists ' .. tgtObject.uid) --TODO; fails for now if we have a uid collision. Perhaps do a smart-update in the future
	else
		self.registry[tgtObject.uid] = tgtObject
		for key, component in pairs(tgtObject:getComponents()) do
			component.registry = self
			component.gid = tgtObject.uid
			component.uid = tgtObject.uid .. '_' .. key
			if component.deferred_bindings then
				for i, binding in ipairs(component.deferred_bindings) do
					component:bindTo(binding.topic, binding.fn, binding.init_with)
				end
				component.deferred_bindings = nil
			end
		end
	end

	return tgtObject.uid
end

function Registry:get ( tgtObjectId )
	return self.registry[tgtObjectId]
end

function Registry:findComponent(poolType, where)
	for i, v in ipairs(self:getGameObjects(poolType)) do
		local isOkay = true
		local component = v:getComponent(poolType)
		for key, value in pairs(where) do
			if not (component[key] == value) then 
				isOkay = false 
			end
		end
		if isOkay then
			return component
		end
	end
	return nil
end

function Registry:getComponent ( tgtObjectUID, poolType )
	local obj = self.registry[tgtObjectUID]
	if not obj then error("Object " .. tostring(tgtObjectUID) .. " not found trying to get its " .. tostring(poolType)) end

	return self.registry[tgtObjectUID]:getComponent(poolType)
end

function Registry:getGameObjects ( pool_filter)
	if pool_filter then
		local filtered = {}
		for i, v in pairs(self.registry) do
			if v:hasComponent(pool_filter) then
				table.insert(filtered, v)
			end
		end
		return filtered
	else
		return self.registry
	end
end

function Registry:publish(topic, message)
	self.pubsub:publish(topic, message)
end

function Registry:subscribe(topic, callback)
	self.pubsub:subscribe(topic, callback)
end

function Registry:bind( component, source, onSourceChange, initWith)
	--Add bound component to bind graph if missing
	if not self.bind_graph:hasNode(component.uid) then
		self.bind_graph:addNode(component.uid)
	end
	--Add source component to bind graph if missing
	if not self.bind_graph:hasNode(source) then
		self.bind_graph:addNode(source)
	end
	--Add bind path
	self.bind_graph:addEdge(source, component.uid)
	self:subscribe(source, function (cmp, msg) 
		onSourceChange(component, component, msg)
	end)
	if initWith then
		onSourceChange(component, component, initWith)
	end
end

function Registry:summarize ( )
	print("Registry has " .. #self.registry .. " entries ")
end

function Registry:getCount ()
	local cnt = 0
	for i, v in pairs(self.registry) do
		cnt = cnt + 1
	end
	return cnt
end

return Registry