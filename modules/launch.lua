local key2App = {
    E = 'org.gnu.Emacs',
    C = 'com.googlecode.iterm2',
    G = 'com.google.Chrome',
--    W = 'com.tencent.xinWeChat',
--    M = 'com.jetbrains.WebStorm',
    D = 'com.jetbrains.datagrip',
    O = 'com.jetbrains.goland',
    P = 'com.jetbrains.PhpStorm',
    F = 'com.google.Chrome.canary',
    V = 'com.microsoft.VSCode',
--    X = 'com.apple.Safari',
--    L = 'com.alibaba.DingTalkMac',
}

for key, app in pairs(key2App) do
    hotkey.bind(hyper, key, function()
                    toggle_application(app)
    end)
end

function toggle_application(_app)
    -- finds a running applications
    local app = application.get(_app)
    if app == nil then
        -- application not running, launch app
        application.launchOrFocusByBundleID(_app)
        return
    end

    if app == nil then
        hs.alert.show("can't find app : " + _app)
    end

    -- application running, toggle hide/unhide
    local mainwin = app:mainWindow()
    if mainwin and mainwin:application() then
        if true == app:isFrontmost() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    else
        application.launchOrFocusByBundleID(_app)
    end
end


hotkey.bind(hyper, '`', 'show bundleid', function()
    local cur = application.frontmostApplication()
    log.i('output current application info...')
    log.i(cur:name())
    log.i(cur:bundleID())
    log.i(cur:path())
    local win = hs.window.focusedWindow()
    if win then
        log.i(win:frame())
        local screen = win:screen()
        local screen_f = screen:frame()
        log.i(screen_f)

        local f = win:frame()
        local s = win:size()
        s.h = screen_f.h
        s.w = screen_f.w
        --s.h = s.h - 10
        --win:setSize(s)
        --win:setFrameInScreenBounds(screen_f)
    end
end)
