-- Hammerspoon --
-- https://github.com/cmsj/hammerspoon-config

require "hs.application"
local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local layout = require 'hs.layout'
local alert = require 'hs.alert'
local hints = require 'hs.hints'
local grid = require 'hs.grid'
local geometry = require 'hs.geometry'

grid.setGrid'10x4'

-- make window transitions much snappier
-- The default duration for animations, in seconds.
-- Initial value is 0.2; set to 0 to disable animations.
window.animationDuration = 0
-- hs.window.setFrameCorrectness = true

-- Defines for window maximize toggler
local frameCache = {}
-- Toggle a window between its normal size, and being maximized
function toggle_window_maximized()
    local win = window.focusedWindow()
    if win == nil then
        return
    end

    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

-- draw a bright red circle around the mouse pointer for a few seconds
function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.getAbsolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:bringToFront(true)
    mouseCircle:show(0.5)

    mouseCircleTimer = hs.timer.doAfter(3, function()
                                            mouseCircle:hide(0.5)
                                            hs.timer.doAfter(0.6, function() mouseCircle:delete() end)
    end)
end

function fullScreen(win)
    local f = win:frame()
    local screen = win:screen()
    local max = screen:fullFrame()
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end

function focusedWindowFirst(fn)
    if window.focusedWindow() then
        fn()
    else
        alert.show("No active window")
    end
end

function resize_win(direction)
    local win = hs.window.focusedWindow()
    if win then
        local f = win:frame()
        local screen = win:screen()
        local max = screen:fullFrame()
        local stepw = max.w/70
        local steph = max.h/30
        local sf = max
        if direction == "right" then f.w = f.w+stepw end
        if direction == "left" then f.w = f.w-stepw end
        if direction == "up" then f.h = f.h-steph end
        if direction == "down" then f.h = f.h+steph end
        if direction == "halfright" then f.x = sf.x+max.w/2 f.y = sf.y f.w = max.w/2 f.h = max.h end
        if direction == "halfright3" then f.x = sf.x+max.w/11*8 f.y = sf.y f.w = max.w/11*3 f.h = max.h end
        if direction == "halfleft" then f.x = sf.x f.y = sf.y f.w = max.w/2 f.h = max.h end
        if direction == "halfleft3" then f.x = sf.x f.y = sf.y f.w = max.w/11*8 f.h = max.h end
        if direction == "halfup" then f.x = sf.x f.y = sf.y f.w = max.w f.h = max.h/2 end
        if direction == "halfup3" then f.x = sf.x+max.w/11*8 f.y = sf.y f.w = max.w/11*3 f.h = max.h/2 end
        if direction == "halfup4" then f.x = sf.x+max.w/5*3 f.y = sf.y f.w = max.w/5*2 f.h = max.h/2 end
        if direction == "halfdown" then f.x = sf.x f.y = sf.y+max.h/2 f.w = max.w f.h = max.h/2 end
        if direction == "halfdown3" then f.x = sf.x+max.w/11*8 f.y = sf.y+max.h/2 f.w = max.w/11*3 f.h = max.h/2 end
        if direction == "halfdown4" then f.x = sf.x+max.w/5*3 f.y = sf.y+max.h/2 f.w = max.w/5*2 f.h = max.h/2 end
        if direction == "cornerNE" then f.x = sf.x+max.w/2 f.y = sf.y f.w = max.w/2 f.h = max.h/2 end
        if direction == "cornerSE" then f.x = sf.x+max.w/2 f.y = sf.y+max.h/2 f.w = max.w/2 f.h = max.h/2 end
        if direction == "cornerNW" then f.x = sf.x f.y = sf.y f.w = max.w/2 f.h = max.h/2 end
        if direction == "cornerSW" then f.x = sf.x f.y = sf.y+max.h/2 f.w = max.w/2 f.h = max.h/2 end
        if direction == "center" then f.x = sf.x+(max.w-f.w)/2 f.y = sf.y+(max.h-f.h)/2 end
        if direction == "fcenter" then f.x = stepw*5 f.y = steph*5 f.w = stepw*20 f.h = steph*20 end
        if direction == "fullscreen" then f = max end
        if direction == "shrink" then f.x = f.x+stepw f.y = f.y+steph f.w = f.w-(stepw*2) f.h = f.h-(steph*2) end
        if direction == "expand" then f.x = f.x-stepw f.y = f.y-steph f.w = f.w+(stepw*2) f.h = f.h+(steph*2) end
        if direction == "mright" then f.x = f.x+stepw end
        if direction == "mleft" then f.x = f.x-stepw end
        if direction == "mup" then f.y = f.y-steph end
        if direction == "mdown" then f.y = f.y+steph end
        log.i('setFrameWithWorkarounds', direction, f, screen, max, sf)
        win:setFrameInScreenBounds(f)
    else
        hs.alert.show("No focused window!")
    end
end

function cycle_wins_next()
    resize_win_list[resize_current_winnum]:focus()
    resize_current_winnum = resize_current_winnum + 1
    if resize_current_winnum > #resize_win_list then resize_current_winnum = 1 end
end

function cycle_wins_pre()
    resize_win_list[resize_current_winnum]:focus()
    resize_current_winnum = resize_current_winnum - 1
    if resize_current_winnum < 1 then resize_current_winnum = #resize_win_list end
end

resize_current_winnum = 1
resize_win_list = hs.window.visibleWindows()

--hotkey.bind(hyperShiftCmd, 'H', 'Shrink Leftward', function() resize_win('left') end, nil, function() resize_win('left') end)
--hotkey.bind(hyperShiftCmd, 'L', 'Stretch Rightward', function() resize_win('right') end, nil, function() resize_win('right') end)
--hotkey.bind(hyperShiftCmd, 'J', 'Stretch Downward', function() resize_win('down') end, nil, function() resize_win('down') end)
--hotkey.bind(hyperShiftCmd, 'K', 'Shrink Upward', function() resize_win('up') end, nil, function() resize_win('up') end)
--hotkey.bind(hyperShiftCmd, 'F', 'Fullscreen', function() resize_win('fullscreen') end, nil, nil)
---- hotkey.bind(hyper, 'C', 'Center Window', function() resize_win('center') end, nil, nil)
--
---- hotkey.bind(hyperShift, 'C', 'Resize & Center', function() resize_win('fcenter') end, nil, nil)
--hotkey.bind(hyperShift, 'H', 'Lefthalf of Screen', function() resize_win('halfleft') end, nil, nil)
--hotkey.bind(hyperShift, 'J', 'Downhalf of Screen', function() resize_win('halfdown') end, nil, nil)
--hotkey.bind(hyperShift, 'K', 'Uphalf of Screen', function() resize_win('halfup') end, nil, nil)
--hotkey.bind(hyperShift, 'L', 'Righthalf of Screen', function() resize_win('halfright') end, nil, nil)
--
--hotkey.bind(hyperShift, 'Y', 'NorthWest Corner', function() resize_win('cornerNW') end, nil, nil)
--hotkey.bind(hyperShift, 'U', 'SouthWest Corner', function() resize_win('cornerSW') end, nil, nil)
--hotkey.bind(hyperShift, 'I', 'SouthEast Corner', function() resize_win('cornerSE') end, nil, nil)
--hotkey.bind(hyperShift, 'O', 'NorthEast Corner', function() resize_win('cornerNE') end, nil, nil)
--hotkey.bind(hyperShift, '=', 'Stretch Outward', function() resize_win('expand') end, nil, function() resize_win('expand') end)
--hotkey.bind(hyperShift, '-', 'Shrink Inward', function() resize_win('shrink') end, nil, function() resize_win('shrink') end)
--hotkey.bind(hyperShiftCtrl, 'H', 'Move Leftward', function() resize_win('mleft') end, nil, function() resize_win('mleft') end)
--hotkey.bind(hyperShiftCtrl, 'L', 'Move Rightward', function() resize_win('mright') end, nil, function() resize_win('mright') end)
--hotkey.bind(hyperShiftCtrl, 'J', 'Move Downward', function() resize_win('mdown') end, nil, function() resize_win('mdown') end)
--hotkey.bind(hyperShiftCtrl, 'K', 'Move Upward', function() resize_win('mup') end, nil, function() resize_win('mup') end)
--
--hotkey.bind(hyperShiftCtrl, 'Y', 'Lefthalf of Screen 3', function() resize_win('halfleft3') end, nil, nil)
--hotkey.bind(hyperShiftCtrl, 'O', 'Righthalfup of Screen 3', function() resize_win('halfright3') end, nil, nil)
--hotkey.bind(hyperShiftCtrl, 'U', 'Righthalfdown of Screen 3', function() resize_win('halfup3') end, nil, nil)
--hotkey.bind(hyperShiftCtrl, 'I', 'Righthalf of Screen 3', function() resize_win('halfdown3') end, nil, nil)
--hotkey.bind(hyperShiftCtrl, '7', 'Righthalfup of Screen 4', function() resize_win('halfup4') end, nil, nil)
--hotkey.bind(hyperShiftCtrl, '8', 'Righthalfdown of Screen 4', function() resize_win('halfdown4') end, nil, nil)


hotkey.bind(hyper, '0', function() mouseHighlight() end)
-- hotkey.bind(hyper, 'tab', function() focusedWindowFirst(
--                     function() toggle_window_maximized() end) end)
hotkey.bind(hyper, '/', function() hints.windowHints() end)
-- hotkey.bind(hyper, '=', function() focusedWindowFirst(
--                     function() fullScreen(hs.window.focusedWindow()) end) end)
