local key2App = {
    -- I = I 不能使用，和 goland 冲突
    -- E = 'org.gnu.Emacs',
    -- C = 'dev.warp.Warp-Stable',
    C = 'com.googlecode.iterm2',
    G = 'com.google.Chrome',
    H = 'com.tencent.xinWeChat',
    -- B = 'com.lencx.chatgpt', -- chatGPT desktop
    B = 'md.obsidian', -- obsidian
    j = 'com.jetbrains.datagrip', -- datagrip
    O = 'com.jetbrains.goland', -- goland
    P = 'com.jetbrains.pycharm', -- pycharm
    L = 'com.todesktop.230313mzl4w4u92', -- cursor
    F = 'com.raycast.macos',
    E = 'com.devon-technologies.think3', -- devonthink3
    W = 'com.kingsoft.wpsoffice.mac',
    -- P = 'com.pake.2653e8',
    M = 'tv.imgo.zaimang',
    N = 'com.electron.logseq',
    K = 'com.TickTick.task.mac',  -- ticktick
    D = 'com.electron.lark', -- lark/feishu
    R = 'com.eusoft.eudic', -- eudic
    U = 'org.yuanli.utools', -- utools
    T = 'ru.keepcoder.Telegram', -- firefox
    V = 'com.microsoft.VSCode', --vscode
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
    log.i('name', cur:name())
    log.i('bundleid', cur:bundleID())
    log.i('path', cur:path())
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
    -- set bundleID to clipboard
    hs.pasteboard.setContents(cur:bundleID())
end)
