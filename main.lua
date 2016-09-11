class = require 'lib/30log'
inspect = require 'lib/inspect'

function love.load()
  print("Time to play!")
end

function love.update(dt)
  --Debug mouse-to-hex output
  if not GLOBAL_PAUSE then

  end
end

function love.draw()
  if not GLOBAL_PAUSE then

  end
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.keypressed(key)

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

