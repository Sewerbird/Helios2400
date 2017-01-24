local PubSub = require 'src/PubSub'
local Binding = require 'src/datatype/Binding'
local Graph = require 'src/structure/Graph'

local Registry = class('Registry', {})

function Registry:init ( )
	self.bind_graph = Graph:new()
	self.structures = {}
	self.index = {}
	self.gid_autoincrement = 1
	self.pubsub = PubSub:new()
end

--Object Lifecycle

function Registry:make( debug_description, components )
	local component_ids = {}
	local gid = 0 + self.gid_autoincrement

	self.index[gid] = { uid = gid }
	--Fill in cells with Components
	for i = 1, #components do
		local component = components[i]
		component.registry = self
		component.gid = gid
		component.uid = gid .. "." .. component.name
		self.index[component.gid][component.name] = component
		--Bindings: at first just lookup, not live
		for key, datum in pairs(component) do
			if datum and type(datum) == 'table' and datum.name == 'Binding' then
				print('datum is ' .. tostring(datum.target) .. '->' .. tostring(datum.component))
				if datum.functor then
					self.index[component.gid][component.name][key] = datum.functor(self:get(datum.target, datum.component))
				else
					self.index[component.gid][component.name][key] = self:get(datum.target, datum.component)
				end
			end
		end

		if component.onFinalized then
			component:onFinalized(self:get(component.gid, component.name),self)
			component.onFinalized = nil
		end
		if component.deferred_bindings then
			for i, binding in ipairs(component.deferred_bindings) do
				component:bindTo(binding.topic, binding.fn, binding.init_with)
			end
			component.deferred_bindings = nil
		end
	end
	--TODO: Hook up Components' Bindings
	self.gid_autoincrement = self.gid_autoincrement + 1
	return gid
end

function Registry:destroy( gid )
	if self.index[gid] then
		self.index[gid] = nil
		--TODO: publish/tidy up
	else
		error("Attempting to remove non-existent game object '" .. gid .. "'")
	end
end

function Registry:get( gid, ctype )
	if self.index[gid] then
		if not ctype then
			return self.index[gid]
		elseif string.find(ctype, "%.") then
			local result = self.index[gid]
			for ele in string.gmatch(ctype, "([^%.]+)") do
				if result then
					if type(result) ~= 'table' then
						print("Warning: attempting to subindex a primitive in " .. gid .. "." .. ctype .. " with '" .. ele .. "' on a value " .. tostring(result))
					else
						result = result[ele]
						if result and type(result) == 'table' and result.class and result.class.name == 'Binding' then
							result = self.index[result.target]
						end
					end
				else
					print("Warning: attempt to retrieve " .. gid .. "." .. ctype .. " failed at '" .. ele .. "'")
				end
			end
			return result
		else
			return self.index[gid][ctype]
		end
	else
		error("Getting cell failed: no game object with gid '" .. gid .."'")
	end
end

function Registry:find( ctype, where, multi)
	local results = {}
	for gid, gob in ipairs(self.index) do
		local component = self:get(gid,ctype)
		if ctype and component then
			local isOkay = true
			for key, value in pairs(where) do
				if not (component[key] == value) then
					isOkay = false
				end
			end
			if isOkay and multi then
				table.insert(results, component)
			elseif isOkay then
				return component
			end
		end
	end
	if #results == 0 and not multi then results = nil end
	return results
end
function Registry:findAll( ctype, where )
	return self:find(ctype, where or {}, true)
end

--PubSub

function Registry:publish(topic, message)
	return self.pubsub:publish(topic, message)
end

function Registry:subscribe(topic, callback)
	return self.pubsub:subscribe(topic, callback)
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

--Structures

function Registry:defineStructure ( name, structure )
	self.structures[name] = structure
end

function Registry:undefineStructure( name )
	self.structures[name] = nil
end

function Registry:view ( name )
	return self.structures[name]
end

return Registry

