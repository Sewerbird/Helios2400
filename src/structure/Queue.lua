local class = require 'lib/30log'
local inspect = require 'lib/inspect'
local Queue = class("Queue", {
	_et = {}
})


function Queue:push (...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
end

function Queue:pop ( num )
    -- get num values from Queue
    local num = num or 1

    -- return table
    local entries = {}

    -- get values into entries
    for i = 1, num do
      -- get last entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[1])
        -- remove last value
        table.remove(self._et, 1)
      else
        break
      end
    end
    -- return unpacked entries
    return unpack(entries)
end

function Queue:peek ()
  return self._et[1]
end

function Queue:peekNext (idx)
  local nxt = idx + 1
  if nxt > #self._et 0 then return nil end
  return self._et[nxt]
end

function Queue:getn ()
	return #self._et
end

function Queue:list ()
	print(inspect(self._et))
end

return Queue