class = require 'lib/30log'
inspect = require 'lib/inspect'
debugGraph = require 'lib/debugGraph'

local AssetLoader = require 'src/AssetLoader'
local Loader = require 'src/Loader'
local Viewer = require 'src/ui/Viewer'
local PubSub = require 'src/PubSub'
local Registry = require 'src/Registry'
local MutatorBus = require 'src/mutate/MutatorBus'

math.randomseed(os.time())
CLIENT_USERNAME = math.random(10000,100000)

--TODO: move this into a util lib
function math.round(n, deci)
  deci = 10^(deci or 0)
  return math.floor(n*deci+.5)/deci
end

function love.load(args)
  CLIENT_USERNAME = args[2] or CLIENT_USERNAME
  print("CLIENT_USERNAME: " .. CLIENT_USERNAME)
  print("Time to play!")

  Global = {
    Registry = Registry:new(),
    Assets = AssetLoader:new():loadAssets("assets/"),
    TickAccumulator = 0,
    TickRate = 0.01,
  }
  Global.Loader = Loader:new(Global)
  Global.Loader:debugLoad()

  --Profiling stuff
  fpsGraph = debugGraph:new('fps', 0, 0, 75)
  memGraph = debugGraph:new('mem', 0, 30, 75)
  dtGraph = debugGraph:new('custom', 0, 60, 75)
  objGraph = debugGraph:new('custom', 0, 90, 75)
  
end

function love.update( dt )
  local gc_cnt = collectgarbage('count')
  if gc_cnt > GOAL_MEMORY then error("Using too much memory mate! \nYou didnt overflow, but you spiked past the design limit of " .. (GOAL_MEMORY/1024) .. "MB, hitting " .. (gc_cnt/1024) .. "MB") end

  --Debug mouse-to-hex output
  if not Global.PAUSE and not Global.PAUSE_UPDATES then
    Global.TickAccumulator = Global.TickAccumulator + dt
    if Global.TickAccumulator > Global.TickRate then
      Global.TickAccumulator = Global.TickAccumulator - Global.TickRate
      local val = math.random()
      Global.Registry:publish('tick',{dt = dt})
    end
  end

  --Profiling stuff
  fpsGraph:update(dt)
  memGraph:update(dt)
  dtGraph:update(dt, math.floor(dt * 1000))
  dtGraph.label = 'DT: ' ..  math.round(dt, 4)
  objGraph:update(dt, Global.Registry:getCount())
  objGraph.label = 'CNT: ' .. Global.Registry:getCount()
end

function love.draw()
  if not Global.PAUSE then
    Global.Viewer.Systems.UIStack:draw()
  end

  -- Profiling stuff
  love.graphics.setColor({100,100,100,100})
  love.graphics.rectangle('fill',0,0,75,120)
  love.graphics.setColor({255,255,255,255})
  fpsGraph:draw()
  memGraph:draw()
  dtGraph:draw()
  objGraph:draw()
end

function love.mousepressed( x, y, button, istouch )
  Global.DRAGBEGUN = true
  Global.Viewer.Systems.UIStack:mousepressed(x, y, button, istouch)
end

function love.mousemoved( x, y, dx, dy, istouch )
  if Global.DRAGBEGUN then
    Global.Viewer.Systems.UIStack:mousedragged(x, y, dx, dy, istouch )
  end
end

function love.mousereleased( x, y, button )
  Global.DRAGBEGUN = false
  --Global.Viewer.Systems.Interface:onUntouch(x,y)
  Global.Viewer.Systems.UIStack:mousereleased(x, y, button, istouch)
end

function love.touchpressed( id, x, y, pressure )
  Global.Viewer.Systems.UIStack:mousepressed(x, y, button, istouch)
end

function love.touchmoved( id, x, y, dx, dy, pressure )
  if Global.DRAGBEGUN then
    Global.Viewer.Systems.UIStack:mousedragged(x, y, dx, dy, istouch )
  end
end

function love.touchreleased( id, x, y, pressure )
  Global.Viewer.Systems.UIStack:mousereleased(x, y, button, istouch)
end

function love.keypressed( key, scancode, isrepeat )
  Global.Viewer.Systems.UIStack:keypressed(key, scancode, isrepeat)
end

function love.keyreleased( key, scancode, isrepeat )
  Global.Viewer.Systems.UIStack:keyreleased(key, scancode, isrepeat)
end

function love.focus( f )
  if not f then
    print("LOST FOCUS")
    Global.PAUSE = true
  else
    print("GAINED FOCUS")
    Global.PAUSE = false
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end

