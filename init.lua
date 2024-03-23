log = hs.logger.new('ccx', 'debug')

require "modules/hotkey"
require "modules/menu"
require "modules/launch"
require "modules/windows"

local cmdalt = {'ctrl', 'alt'}

-- Set grid size.
hs.grid.GRIDWIDTH  = 6
hs.grid.GRIDHEIGHT = 6
hs.grid.MARGINX    = 0
hs.grid.MARGINY    = 0
hs.window.animationDuration = 0

hs.application.enableSpotlightForNameSearches(true)


hs.hotkey.bind(cmdalt, 'J', hs.grid.pushWindowDown)
hs.hotkey.bind(cmdalt, 'K', hs.grid.pushWindowUp)
hs.hotkey.bind(cmdalt, 'H', hs.grid.pushWindowLeft)
hs.hotkey.bind(cmdalt, 'L', hs.grid.pushWindowRight)

hs.hotkey.bind(cmdalt, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(cmdalt, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(cmdalt, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind(cmdalt, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.h / 2
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)



hs.hotkey.bind(cmdalt, "return", function() focusedWindowFirst(
  function() toggle_window_maximized() end) end)



local sizeup = {}

--- Multiple Monitor Actions ---
-- Send Window Prev Monitor
hs.hotkey.bind( cmdalt , "," , function()
  sizeup.send_window_prev_monitor()
end)
-- Send Window Next Monitor
hs.hotkey.bind( cmdalt , "." , function()
  sizeup.send_window_next_monitor()
end)

function sizeup.send_window_prev_monitor()
  hs.alert.show("Prev Monitor")
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():previous()
  win:moveToScreen(nextScreen)
end

function sizeup.send_window_next_monitor()
  hs.alert.show("Next Monitor")
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():next()
  win:moveToScreen(nextScreen)
end



--- hs.window:moveToScreen(screen)
--- Method
--- move window to the the given screen, keeping the relative proportion and position window to the original screen.
--- Example: win:moveToScreen(win:screen():next()) -- move window to next screen
function hs.window:moveToScreen(nextScreen)
  local currentFrame = self:frame()
  local screenFrame = self:screen():frame()
  local nextScreenFrame = nextScreen:frame()
  self:setFrame({
    x = ((((currentFrame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x),
    y = ((((currentFrame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y),
    h = ((currentFrame.h / screenFrame.h) * nextScreenFrame.h),
    w = ((currentFrame.w / screenFrame.w) * nextScreenFrame.w)
  })
end

hs.alert.show("Hammerspoon, at your service.", 3)
