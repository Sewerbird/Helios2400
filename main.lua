class = require 'lib/30log'
inspect = require 'lib/inspect'
ProFi = require 'lib/ProFi'

GameObject = require 'src/GameObject'
Interfaceable = require 'src/Interfaceable'
Renderable = require 'src/Renderable'
Transform = require 'src/Transform'
Polygon = require 'src/Polygon'
TouchDelegate = require 'src/TouchDelegate'
Sprite = require 'src/Sprite'

function love.load()
  print("Time to play!")

  ProFi:start()

  Debug_Spritesheet = love.graphics.newImage('assets/debug_tileset.png')
  Debug_Hex_Quad = love.graphics.newQuad(0, 0, 168, 146, Debug_Spritesheet:getDimensions())
  Debug_Unit_Quad = love.graphics.newQuad(168, 0, 50, 50, Debug_Spritesheet:getDimensions())

  Debug_Hex = GameObject:new({
    Interfaceable:new(
      Transform:new(100,100),
      Polygon:new({ 41,0 , 127,0 , 168,73 , 127,146 , 41,146 , 0,73 }),
      TouchDelegate:new()),
    Renderable:new(
      Transform:new(100,100),
      Polygon:new({ 41,0 , 127,0 , 168,73 , 127,146 , 41,146 , 0,73 }),
      Sprite:new(Debug_Spritesheet, Debug_Hex_Quad))
    })
  Debug_Unit = GameObject:new({
    Interfaceable:new(
      Transform:new(100,100),
      Polygon:new({ w = 50, h = 50 }),
      TouchDelegate:new()),
    Renderable:new(
      Transform:new(100,100),
      Polygon:new({ w = 50, h = 50 }),
      Sprite:new(Debug_Spritesheet, Debug_Unit_Quad))
    })

end

function love.update(dt)
  --Debug mouse-to-hex output
  if not GLOBAL_PAUSE then
  end
end

function love.draw()
  if not GLOBAL_PAUSE then
    Debug_Hex:getComponent('Renderable'):draw()
    Debug_Unit:getComponent('Renderable'):draw()
    local delta = love.timer.getFPS()
    love.graphics.print({{255,5,5}, "FPS: " .. delta}, 10, 10, 0, 4, 4)
  end
end

function love.mousepressed(x, y, button)
  GLOBAL_DRAGBEGUN = true
  Debug_Hex:getComponent('Interfaceable'):onTouch(x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
  if GLOBAL_DRAGBEGUN then
    Debug_Hex:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
  else
    Debug_Hex:getComponent('Interfaceable'):onHover(x, y)
  end
end

function love.mousereleased(x, y, button)
  GLOBAL_DRAGBEGUN = false
  Debug_Hex:getComponent('Interfaceable'):onUntouch(x, y)
end

function love.touchpressed(id, x, y, pressure)
  Debug_Hex:getComponent('Interfaceable'):onTouch(x, y)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  Debug_Hex:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
end

function love.touchreleased(id, x, y, pressure)
  Debug_Hex:getComponent('Interfaceable'):onUntouch(x, y)
end

function love.keypressed(key)
  Debug_Hex:getComponent('Interfaceable'):onKeypress(key)
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

