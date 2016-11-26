class = require 'lib/30log'
inspect = require 'lib/inspect'
ProFi = require 'lib/ProFi'
debugGraph = require 'lib/debugGraph'

local AssetLoader = require 'src/AssetLoader'
local Loader = require 'src/Loader'
local GameViewer = require 'src/ui/GameViewer'
local PubSub = require 'src/PubSub'
local Registry = require 'src/Registry'
local MutatorBus = require 'src/mutate/MutatorBus'
local my_viewer

--TODO: move this into a util lib
function math.round(n, deci)
  deci = 10^(deci or 0)
  return math.floor(n*deci+.5)/deci
end

function love.load()
  print("Time to play!")

  Global = {
    Registry = Registry:new(),
    Assets = AssetLoader:new():loadAssets("assets/"),
    TickAccumulator = 0,
    TickRate = 0.1
  }
  Global.MutatorBus = MutatorBus:new(Global.Registry)
  SceneGraph = Loader:new(Global):debugLoad()

  my_viewer = GameViewer:new(Global.Registry, SceneGraph)

  --Profiling stuff
  ProFi:start()
  fpsGraph = debugGraph:new('fps', 0, 0, 75)
  memGraph = debugGraph:new('mem', 0, 30, 75)
  dtGraph = debugGraph:new('custom', 0, 60, 75)
  objGraph = debugGraph:new('custom', 0, 90, 75)
  
end

function love.update( dt )
  if collectgarbage('count') > GOAL_MEMORY then error('Using too much memory mate!') end

  --Debug mouse-to-hex output
  if not Global.PAUSE then
    Global.TickAccumulator = Global.TickAccumulator + dt
    if Global.TickAccumulator > Global.TickRate then
      Global.TickAccumulator = Global.TickAccumulator - Global.TickRate
      local val = math.random()
      Global.Registry:publish('tick',{percent = val})
      my_viewer.Systems.Render:update(dt)
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
    my_viewer.Systems.Render:draw()
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

function love.mousepressed( x, y, button )
  Global.DRAGBEGUN = true
  my_viewer.Systems.Interface:onTouch(x,y)
end

function love.mousemoved( x, y, dx, dy, istouch )
  if Global.DRAGBEGUN then
    my_viewer.Systems.Interface:onDrag(x,y,dx,dy)
  end
end

function love.mousereleased( x, y, button )
  Global.DRAGBEGUN = false
  my_viewer.Systems.Interface:onUntouch(x,y)
end

function love.touchpressed( id, x, y, pressure )
  my_viewer.Systems.Interface:onTouch(x,y)
end

function love.touchmoved( id, x, y, dx, dy, pressure )
  if Global.DRAGBEGUN then
    my_viewer.Systems.Interface:onDrag(x,y,dx,dy)
  end
end

function love.touchreleased( id, x, y, pressure )
  my_viewer.Systems.Interface:onUntouch(x,y)
end

function love.keypressed( key )
  my_viewer.Systems.Interface:onKeypress(key)
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
  ProFi:stop()
  ProFi:writeReport( 'MyProfilingReport.txt' )
end

