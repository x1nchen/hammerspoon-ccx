------------- Set hyper to ctrl + cmd ---------------
hyper = {'ctrl', 'cmd'}
hyperShiftCmd = {'cmd', 'shift'}
hyperShiftCtrl = {'shift', 'ctrl'}
hyperShift = {'ctrl', 'cmd', 'shift'}

--  define modules
hotkey = require 'hs.hotkey'
window = require 'hs.window'
application = require 'hs.application'

-- hammerspoon console
hotkey.bind(hyper, '-', hs.openConsole)
