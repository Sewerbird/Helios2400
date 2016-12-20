function love.conf(t)
  t.title = 'Helios 2400'
  t.window.width = 1200
  t.window.height = 800
  t.window.highdpi = false
  t.fullscreen = true
  t.console = true

  GOAL_MEMORY = 1024 * 64 --64 Megabytes
  BG_MUSIC_VOL = 0.015

  return t;
end
