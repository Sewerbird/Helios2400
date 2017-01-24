inspect = require 'lib/inspect'
local Cell
local CellReferrer 
local Component
local Binding

--[[

# Registry

A registry provides an interface to a reactive, spreadsheet-like object database

--]]

	local Registry = {
		data = {},
		autoincrement = 1
	}
	Registry.__index = Registry
	function Registry:new (o)
		o = o or {}
		setmetatable(o, self)
		return o
	end

	function Registry:_consumeTag()
		local tag = self.autoincrement
		self.autoincrement = self.autoincrement + 1
		return tag
	end

--[[

## Querying

The data is stored in Objects referenced by a `gid`, an integer index. Each object
is associated with a table that contains a description of the object and a list of
components that it stores. A CellReferrer monitors each entry in this list, and 
stores Cells that are related to a single component type (although the CellReferrer
can support many components of the same type).

### `:get`

A user may ask for a specific component by using the `get` function, which takes a
`gid` and a `path` parameter. Paths are dot-seperated strings that navigate the
desired fields in the object. 

Example

    registry:get(9310, "ArmyInfo.owner.colors.midtone")

--]]

	function Registry:get ( gid, path )
		if self.data[gid] then
			local result = self.data[gid]._c
			for ele in string.gmatch(path, "([^%.]+)") do 
				print("Accessing " .. ele .. " on " .. inspect(result, {depth=5}))
				if type(result) == 'table' and result._type == 'bind' then
					result = result.functor(self:get(result.target, result.path))
					if type(result) == 'table' then
						result = result[ele]
					end
				else
					result = result[ele]
				end
			end
			if type(result) == 'table' and result._type == 'bind' then
				result = self:get(result.target, result.path)
			end
			return result
		else
			error('Game object ' .. gid .. ' not found ')
		end
	end

--[[

### `:find` / `:findAll`

A user may ask for all components of a given type using the `find` function, which
takes a component type and an optional 'where clause' table

Example

    registry:find("ArmyInfo", { 'owner.name' = 'Edward' })

--]]

	function Registry:find ( ctype, where, options )
		local results = {}
		for gid, gob in ipairs(self.data) do
			if gob._c[ctype] then
				local passes = true
				if where then
					for criteria, standard in pairs(where) do
						if self.data[gid]._c[ctype][criteria] ~= standard then
							passes = false
						end
					end
				end
				if passes then
					if options and options.multi then
						table.insert(results, self.data[gid]._c[ctype])
					else 
						return self.data[gid]._c[ctype] 
					end
				end
			end
		end
		return options and options.multi and results or nil
	end

	function Registry:findAll( ctype, where )
		return self:find( ctype, where or {}, {multi = true})
	end

--[[

## Creating/Deleting

Objects in the registry can be created using the `make` and `destroy` commands.
Such objects are made up of a brief textual description and their constituent
components. 

### `:make`

A user create an object by calling `make` with a description and a table full of
components. Components must implement/inherit the Component.lua class, chiefly by
providing a `_name` and using `_cells` for internal data (to enable the binding and
other affordances enabled by CellReferrer). The function returns the `gid` of the
created object for later use.

Example

    my_gid = registry:make("A small object", { 
		Link:new(288309,"Transform", function(src, tgt) 
			return src:copy():translate(5,5)
		end),
		Renderable:new(
			{ --background
				polygon = Polygon:new({w = 10, h = 10}),
				bg_color = Binding:new(9310,"ArmyInfo.owner.colors.midtone")
			}
		)
	})

--]]


--[[
Registry maintains a Graph
	The Graph's nodes are datatypes with the Binding datatype
	The Graph's directed edges point from source to dependee
When a Datum is added and it is of the Binding datatype
	The datum is inserted as any other datatype
	The gid of the target is noted, and the registry subscribes to '<gid>/<component>'
When a Datum is accessed and it is of the Binding datatype
	The Binding's target is added to the Path of the lookup and proceeds
When a Datum is updated and its gid is in the Binding graph
	The registry publishes to '<gid>/<component>'
	(Recurse as necessary/appropriate)
--]]
	function Registry:make( description, components )
		--Register object
		local gid = self:_consumeTag()
		self.data[gid] = { _d = description, _c = {}}

		--Register components
		for i = 1, #components do
			local component = components[i]
			self.data[gid]._c[component._name] = component --CellReferrer:new(component)
			for key, cell in pairs(component._cells) do
				self.data[gid]._c[component._name][key] = cell
			end
		end

		return gid
	end

--[[

### `:destroy`

A user may remove an object entirely from the registry by destroying it. This also
notifies all cells depending on the object's cells of the change.

Example

	registry:get(9310, "ArmyInfo") --Something
	registry:destroy(9310)
	registry:get(9310, "ArmyInfo") --nil

--]]

	function Registry:destroy ( gid )
		--TODO: handle unbinding
		self.data[gid] = nil
	end

--[[

# Cell Class

The cell class serves as the basic container for object data, and functions as a
simple variable wrapper, or a full binding.

--]]

	Cell = {
		_value = nil
	}
	Cell.__index = Cell
	function Cell:new (registry, value)
		local o = {}
		o._registry = registry
		o._value = value
		setmetatable(o, self)
		return o
	end

--[[

## Evaluation

The value stored in a cell is retrieved via the `:eval` function. In the case where
the cell is a simple variable wrapper, it returns the value originally passed to 
the cell. 

In the case where the cell is a binding, the registry is consulted to get the current
value of the targetted cell. If a functor is specified in the binding, then the cell 
returns the value returned by the functor, given the value.

--]]

	function Cell:eval ()
		print("Calling eval on self: " .. inspect(self))
		if self.functor then
			--TODO: do fetch
			error('TODO: eval() ' .. self.target)
			val = self._registry:get()
			if self.functor then
				self._value = self.functor(val)
			else self._value = val end
		end
		return self._value
	end

--[[

# Component

--]]

	Component = {
		_cells = {},
		_name = 'Component'
	}
	Component.__index = Component
	function Component:new (name, obj)
		local o = {}
		o._name = name or 'Component'
		o._cells = obj or {}
		setmetatable(o, self)
		return o
	end
	function Component:__index(key)
		if rawget(self,'_cells')[key] ~= nil then
			return (rawget(self,'_cells')[key]):eval()
		elseif getmetatable(self)[key] then
			return getmetatable(self)[key]
		end
		return nil
	end

	function Component:__newindex(key, val)
		rawset(rawget(self,'_cells'), key, Cell:new(rawget(self,'_registry'), val))
	end

--[[

# Binding

--]]

	Binding = {
		_type = 'bind',
		target = nil,
		path = nil,
		functor = function (val) return val end
	}
	Binding.__index = Binding
	function Binding:new (target, path, functor)
		local o = {}
		setmetatable(o, self)
		o.target = target
		o.path = path
		o.functor = functor
		return o
	end

--And that's all! Use `Registry = require("Registry")` in code that you want to use the Registry in
return function() return Registry, Component, Binding end
