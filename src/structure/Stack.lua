local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Stack = class("Stack", {
	_et = {}
})


function Stack:push (...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
end

function Stack:pop ( num )
    -- get num values from stack
    local num = num or 1

    -- return table
    local entries = {}

    -- get values into entries
    for i = 1, num do
      -- get last entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[#self._et])
        -- remove last value
        table.remove(self._et)
      else
        break
      end
    end
    -- return unpacked entries
    return unpack(entries)
end

function Stack:peek ()
  if #self._et == 0 then return nil end
  return self._et[#self._et]
end

function Stack:peekNext (idx)
  local nxt = #self._et - idx
  if nxt <= 0 then return nil end
  return self._et[nxt]
end

function Stack:getn ()
	return #self._et
end

function Stack:list ()
	print(inspect(self._et))
end

return Stack