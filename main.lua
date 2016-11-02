class = require 'lib/30log'
inspect = require 'lib/inspect'
ProFi = require 'lib/ProFi'

Loader = require 'src/Loader'


function love.load()
  print("Time to play!")

  ProFi:start()

  Loader:new():debugLoad()
end

function love.update( dt )
  --Debug mouse-to-hex output
  if not Global_PAUSE then
  end
end

function love.draw()
  if not Global_PAUSE then

    Global.Systems.Render:draw()

    local delta = love.timer.getFPS()
    love.graphics.print({{255,5,5}, "FPS: " .. delta}, 10, 10, 0, 1, 1)
  end
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

