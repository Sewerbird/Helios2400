function love.conf(t)
  t.title = 'Helios 2400'
  t.window.width = 800
  t.window.height = 600
  t.window.highdpi = false
  t.window.resizable = true
  t.fullscreen = true
  t.console = true

  GOAL_MEMORY = 1024 * 64 --64 Megabytes
  BG_MUSIC_VOL = 0.015

  return t;
end
