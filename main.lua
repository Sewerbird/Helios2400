class = require 'lib/30log'
inspect = require 'lib/inspect'
ProFi = require 'lib/ProFi'
debugGraph = require 'lib/debugGraph'

Loader = require 'src/Loader'

--TODO: move this into a util lib
function math.round(n, deci)
  deci = 10^(deci or 0)
  return math.floor(n*deci+.5)/deci
end

function love.load()
  print("Time to play!")

  Loader:new():debugLoad()

  --Profiling stuff
  ProFi:start()
  fpsGraph = debugGraph:new('fps', 0, 0)
  memGraph = debugGraph:new('mem', 0, 30)
  dtGraph = debugGraph:new('custom', 0, 60)
  
end

function love.update( dt )

  --Debug mouse-to-hex output
  if not Global_PAUSE then
  end

  --Profiling stuff
  fpsGraph:update(dt)
  memGraph:update(dt)
  dtGraph:update(dt, math.floor(dt * 1000))
  dtGraph.label = 'DT: ' ..  math.round(dt, 4)
end

function love.draw()
  if not Global_PAUSE then
    Global.Systems.Render:draw()
  end

  -- Profiling stuff
  fpsGraph:draw()
  memGraph:draw()
  dtGraph:draw()
end

function love.mousepressed( x, y, button )
  Global.DRAGBEGUN = true
  Global.Systems.Interface:onTouch(x,y)
end

function love.mousemoved( x, y, dx, dy, istouch )
  if Global.DRAGBEGUN then
    Global.Systems.Interface:onDrag(x,y,dx,dy)
  end
end

function love.mousereleased( x, y, button )
  Global.DRAGBEGUN = false
  Global.Systems.Interface:onUntouch(x,y)
end

function love.touchpressed( id, x, y, pressure )
  Global.Systems.Interface:onTouch(x,y)
end

function love.touchmoved( id, x, y, dx, dy, pressure )
  if Global.DRAGBEGUN then
    Global.Systems.Interface:onDrag(x,y,dx,dy)
  end
end

function love.touchreleased( id, x, y, pressure )
  Global.Systems.Interface:onUntouch(x,y)
end

function love.keypressed( key )
  Global.Systems.Interface:onKeypress(key)
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

