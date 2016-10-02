class = require 'lib/30log'
inspect = require 'lib/inspect'
ProFi = require 'lib/ProFi'

Loader = require 'src/Loader'
InterfaceableSystem = require 'src/InterfaceableSystem'
RenderableSystem = require 'src/RenderableSystem'


function love.load()
  print("Time to play!")

  ProFi:start()

  debugScene = Loader:new():debugLoad()

  Sys_Renderable = RenderableSystem:new()
  Sys_Renderable:addScene('earth_view', debugScene)
  Sys_Renderable:setScene('earth_view')

  Sys_Interfaceable = InterfaceableSystem:new()
  Sys_Interfaceable.rootGameObject = debugScene


end

function love.update(dt)
  --Debug mouse-to-hex output
  if not GLOBAL_PAUSE then
  end
end

function love.draw()
  if not GLOBAL_PAUSE then

    Sys_Renderable:draw()

    local delta = love.timer.getFPS()
    love.graphics.print({{255,5,5}, "FPS: " .. delta}, 10, 10, 0, 1, 1)
  end
end

function love.mousepressed(x, y, button)
  GLOBAL_DRAGBEGUN = true
  Sys_Interfaceable:onTouch(x,y)
end

function love.mousemoved(x, y, dx, dy, istouch)
  if GLOBAL_DRAGBEGUN then
    Sys_Interfaceable:onDrag(x,y,dx,dy)
  else
    Sys_Interfaceable:onHover(x,y)
  end
end

function love.mousereleased(x, y, button)
  GLOBAL_DRAGBEGUN = false
  Sys_Interfaceable:onUntouch(x,y)
end

function love.touchpressed(id, x, y, pressure)
  Sys_Interfaceable:onTouch(x,y)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  Sys_Interfaceable:onDrag(x,y,dx,dy)
end

function love.touchreleased(id, x, y, pressure)
  Sys_Interfaceable:onUntouch(x,y)
end

function love.keypressed(key)
  Sys_Interfaceable:onKeypress(key)
end


function love.focus(f)
  if not f then
    print("LOST FOCUS")
    GLOBAL_PAUSE = true
  else
    print("GAINED FOCUS")
    GLOBAL_PAUSE = false
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
  ProFi:stop()
  ProFi:writeReport( 'MyProfilingReport.txt' )
end

