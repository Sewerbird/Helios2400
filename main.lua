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

  local Debug_Spritesheet = love.graphics.newImage('assets/debug_tileset.png')
  local Debug_Hex_Quad = love.graphics.newQuad(0, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Debug_Hex2_Quad = love.graphics.newQuad(84, 0, 84, 73, Debug_Spritesheet:getDimensions())
  local Debug_Unit_Quad = love.graphics.newQuad(168, 0, 50, 50, Debug_Spritesheet:getDimensions())

  local Debug_Hex = GameObject:new({
    Interfaceable:new(
      Transform:new(100,100),
      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
      TouchDelegate:new()),
    Renderable:new(
      Transform:new(100,100),
      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
      Sprite:new(Debug_Spritesheet, Debug_Hex_Quad))
    })
  local Debug_Hex2 = GameObject:new({
    Interfaceable:new(
      Transform:new(200,100),
      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
      TouchDelegate:new()),
    Renderable:new(
      Transform:new(200,100),
      Polygon:new({ 20,0 , 63,0 , 84,37 , 63,73 , 20,73 , 0,37 }),
      Sprite:new(Debug_Spritesheet, Debug_Hex2_Quad))
    })
  local Debug_Unit = GameObject:new({
    Interfaceable:new(
      Transform:new(100 + 42 - 25,100 + 37 - 25),
      Polygon:new({ w = 50, h = 50 }),
      TouchDelegate:new()),
    Renderable:new(
      Transform:new(100 + 42 - 25, 100 + 37 - 25),
      Polygon:new({ w = 50, h = 50 }),
      Sprite:new(Debug_Spritesheet, Debug_Unit_Quad))
    })


  Scene = GameObject:new()
  local Tile_Layer = GameObject:new()
  local Unit_Layer = GameObject:new()
  local UI_Layer = GameObject:new()

  Scene:addChild(UI_Layer)
  Scene:addChild(Tile_Layer)
  Scene:addChild(Unit_Layer)

  Tile_Layer:addChild(Debug_Hex)
  Tile_Layer:addChild(Debug_Hex2)
  Unit_Layer:addChild(Debug_Unit)

end

local function naive_fullscene_recurse ( function_on_gameobject )
  local function recurse (elements)
    for i, child in ipairs(elements) do
      function_on_gameobject(child)
      recurse(child:getChildren())
    end
  end
  recurse(Scene:getChildren())
end

function love.update(dt)
  --Debug mouse-to-hex output
  if not GLOBAL_PAUSE then
  end
end

function love.draw()
  if not GLOBAL_PAUSE then
    local function recursive_draw(gob)
      if gob:hasComponent('Renderable') then
        gob:getComponent('Renderable'):draw()
      end
    end
    naive_fullscene_recurse(recursive_draw)

    local delta = love.timer.getFPS()
    love.graphics.print({{255,5,5}, "FPS: " .. delta}, 10, 10, 0, 1, 1)
  end
end

function love.mousepressed(x, y, button)
  GLOBAL_DRAGBEGUN = true
  local function func(gob)
    if gob:hasComponent('Interfaceable') then
      gob:getComponent('Interfaceable'):onTouch(x, y)
    end
  end
  naive_fullscene_recurse(func)
end

function love.mousemoved(x, y, dx, dy, istouch)
  if GLOBAL_DRAGBEGUN then
    local function func(gob)
      if gob:hasComponent('Interfaceable') then
        gob:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
      end
    end
    naive_fullscene_recurse(func)
  else
    local function func(gob)
      if gob:hasComponent('Interfaceable') then
        gob:getComponent('Interfaceable'):onHover(x, y)
      end
    end
    naive_fullscene_recurse(func)
  end
end

function love.mousereleased(x, y, button)
  GLOBAL_DRAGBEGUN = false
  local function func(gob)
    if gob:hasComponent('Interfaceable') then
      gob:getComponent('Interfaceable'):onUntouch(x, y)
    end
  end
  naive_fullscene_recurse(func)
end

function love.touchpressed(id, x, y, pressure)
  local function func(gob)
    if gob:hasComponent('Interfaceable') then
      gob:getComponent('Interfaceable'):onTouch(x, y)
    end
  end
  naive_fullscene_recurse(func)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  local function func(gob)
    if gob:hasComponent('Interfaceable') then
      gob:getComponent('Interfaceable'):onDrag(x, y, dx, dy)
    end
  end
  naive_fullscene_recurse(func)
end

function love.touchreleased(id, x, y, pressure)
  local function func(gob)
    if gob:hasComponent('Interfaceable') then
      gob:getComponent('Interfaceable'):onUnouch(x, y)
    end
  end
  naive_fullscene_recurse(func)
end

function love.keypressed(key)
  local function func(gob)
    if gob:hasComponent('Interfaceable') then
      gob:getComponent('Interfaceable'):onKeypress(key)
    end
  end
  naive_fullscene_recurse(func)
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

