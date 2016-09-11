class = require 'lib/30log'
inspect = require 'lib/inspect'

GameObject = require 'src/GameObject'
Interfaceable = require 'src/Interfaceable'
Renderable = require 'src/Renderable'
Transform = require 'src/Transform'
Polygon = require 'src/Polygon'
TouchDelegate = require 'src/TouchDelegate'

function love.load()
  print("Time to play!")

  Main_Screen = GameObject:new({
    Interfaceable:new(
      Transform:new(0,0),
      Polygon:new({w = 600, h = 400}),
      TouchDelegate:new()),
    Renderable:new(
      Transform:new(0,0),
      Polygon:new({w = 600, h = 400}))
    })

end

function love.update(dt)
  --Debug mouse-to-hex output
  if not GLOBAL_PAUSE then

  end
end

function love.draw()
  if not GLOBAL_PAUSE then
    Main_Screen:getComponent('Renderable'):draw()
  end
end

function love.mousepressed(x, y, button)
  GLOBAL_DRAGBEGUN = true
  Main_Screen:getComponent('Interfaceable'):onTouch(x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
  if GLOBAL_DRAGBEGUN then
    Main_Screen:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
  else
    Main_Screen:getComponent('Interfaceable'):onHover(x, y)
  end
end

function love.mousereleased(x, y, button)
  GLOBAL_DRAGBEGUN = false
  Main_Screen:getComponent('Interfaceable'):onUntouch(x, y)
end

function love.touchpressed(id, x, y, pressure)
  Main_Screen:getComponent('Interfaceable'):onTouch(x, y)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  Main_Screen:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
end

function love.touchreleased(id, x, y, pressure)
  Main_Screen:getComponent('Interfaceable'):onUntouch(x, y)
end

function love.keypressed(key)
  Main_Screen:getComponent('Interfaceable'):onKeypress(key)
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
end

