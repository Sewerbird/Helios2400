local PubSub = require 'src/PubSub'
local Binding = require 'src/datatype/Binding'

local Registry = class('Registry', {})

function Registry:init ( )
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
				print('looking up ' .. ele)
				if result then
					if type(result) ~= 'table' then
						print("Warning: attempting to subindex a primitive in " .. gid .. "." .. ctype .. " with '" .. ele .. "' on a value " .. tostring(result))
					else
						result = result[ele]
						print('yields ' .. tostring(result))
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
	--if not self.bind_graph:hasNode(component.uid) then
	--	self.bind_graph:addNode(component.uid)
	--end
	--Add source component to bind graph if missing
	--if not self.bind_graph:hasNode(source) then
	--	self.bind_graph:addNode(source)
	--end
	--Add bind path
	--self.bind_graph:addEdge(source, component.uid)
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


--[[

Sample usages

gidPlayer = registry:makeObject("Cool player dude", { --310
	PlayerInfo:new({
		highlight_color = {200,200,200},
		midtone_color = {100,100,100},
		darkened_color = {50,50,50}
	})
})
gidArmy = registry:makeObject("A particular army", { --9310
	ArmyInfo:new({
		sprite = "FooSprite",
		name = "FooArmy",
		owner = Binding:new("310","PlayerInfo"),
		address = "WesternEurope_0",
		map = "Earth"
	})
})
gidIcon = registry:makeObject("A army view icon", {
	ArmyInfo:link("9310"),
	Transform:link("288309", function(src, tgt) 
		return src:copy():translate(5,5)
	end),
	Renderable:new([ --drawn front-to-back
		{ --background
			polygon = Polygon:new({w = 10, h = 10}),
			bg_color = Binding:new("this","ArmyInfo.owner.darkened_color"), --'owner' is a link in the source to a PlayerInfo
		},
		{ --unit sprite
			polygon = Polygon:new({w = 10, h = 10}),
			render = Binding:new("this","ArmyInfo.sprite"),
			bg_color = Binding:new("this","ArmyInfo.owner.midtone_color"), --'owner' is a link in the source to a PlayerInfo
			text = Binding:new("this","ArmyInfo", function(src, tgt)
				return src.name + " (" + src.owner:lookup("name") + ")"
			end
		},
		{ --health bar
			polygon = Binding:new("this","ArmyInfo", function(src, tgt)
				return Polygon:new({x = 0, y = 9, w = (src.curr_hp / src.max_hp) * 10, h})
			end),
			bg_color = Binding:new("this","ArmyInfo.owner.highlight_color")
		},
		{ --name
			polygon = Polygon:new({x = 0, y = 0, w = 10, h = 3}),
			text = Binding:new("this","ArmyInfo", function(src, tgt)
				return src.name + " (" + src.owner:lookup("name") + ")"
			end)
		},
		{ --move counter
			polygon = Polygon:new({x = 0, y = 6, w = 3, h = 3}),
			text = Binding:new("this","ArmyInfo", function(src, tgt)
				return src.curr_move
			end)
		},
		{ --shader for when unit is 'done'
			polygon = Binding:new("this","ArmyInfo", function(src, tgt)
				if src.curr_move == 0 or src.sleeping then
					return Polygon:new({w = 0, h = 0})
				else 
					return Polygon:new({w = 10, h = 10}) 
				end
			end),
			bg_color = {0,0,0,100}
		}
	]),
	Interfaceable:new({
		polygon = Binding:new("this",{w = 10, h = 10}),
		delegate = TouchDelegate:new(function() ... end)
	})
})
registry:get("9310", "ArmyInfo") --returns the ArmyInfo component for GameObject 9310
registry:find("ArmyInfo", {"map" = "Earth"}) --returns the ArmyInfo(s) that have `map` == "Earth"
registry:defineStructure('z-order', Tree:new()) --defines a structure (ring, array, stack, queue, graph...) over gameobject ids
registry:in('z-order'):attach(gidIcon, gidLayer) --attaches the view icon to a view layer in the `z-order` structure graph
registry:remove("9310") --deletes GameObject9310, and orphaned components thereof
registry:undefineStructure('z-order')

--]]
