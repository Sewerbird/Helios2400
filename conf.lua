function love.conf(t)
  t.title = 'Helios 2400'
  t.window.width = 1200
  t.window.height = 800
  t.fullscreen = true
	t.console = true

  GOAL_MEMORY = 1024 * 64 --64 Megabytes
  BG_MUSIC_VOL = 0.15

  return t;
end
