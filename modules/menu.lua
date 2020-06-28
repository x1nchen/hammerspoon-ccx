-- reload
config_reload = function ()
    log.i()
    log.i('ready to reload config ...')
    log.i()

    hs.notify.show('ccx', 'Hammerspoon', 'hotkey trigger config reload ....')

    hs.reload()
end

hotkey.bind(hyper, '\\', config_reload)


local switchers = {}


-- set up your windowfilter
-- switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
-- switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
-- switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'} -- specialized switcher for your dozens of browser windows :)

-- bind to hotkeys; WARNING: at least one modifier key is required!
-- hs.hotkey.bind('alt','tab','Next window',function()switcher_space:next()end)
-- hs.hotkey.bind('alt-shift','tab','Prev window',function()switcher_space:previous()end)

-- alternatively, call .nextWindow() or .previousWindow() directly (same as hs.window.switcher.new():next())
-- hs.hotkey.bind('alt','tab','Next window 1',hs.window.switcher.nextWindow)
-- you can also bind to `repeatFn` for faster traversing
-- hs.hotkey.bind('alt-shift','tab','Prev window 2',hs.window.switcher.previousWindow,nil,hs.window.switcher.previousWindow)

function get_switcher()
    local cur = application.frontmostApplication()
    local n = cur:name()
    local s = switchers[n]
    if s == nil then
        s = hs.window.switcher.new{n}
        s.ui.highlightColor = {0.4,0.4,0.5,0.8}
        s.ui.thumbnailSize = 112
        s.ui.selectedThumbnailSize = 284
        s.ui.backgroundColor = {0.3, 0.3, 0.3, 0.5}
        s.ui.fontName = 'System'
        s.ui.textSize = 14
        s.ui.showSelectedTitle = false
        switchers[n] = s
    end
    return s
end

hs.window.animationDuration = 0

-- hs.hotkey.bind('alt', '[', 'Prev window', function()
--                    get_switcher():previous()
-- end)
--
--
-- hs.hotkey.bind('alt', ']', 'Next window', function()
--                    get_switcher():next()
-- end)
