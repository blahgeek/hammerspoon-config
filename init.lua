-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2018-06-14

-- watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/",
--                              (function(files)
--                                   hs.reload()
--                                   hs.notify.show("HammerSpoon", "", "Config reloaded", "")
--                               end))
-- watcher:start()
--
require('hs.ipc')
require('hs.eventtap')
require('hs.spoons')

spoon = {}

hs.spoons.use('ModsKeybind', {
        config = {
            timeout = 0.15,
            key = "ctrl",
            action = function() hs.eventtap.keyStroke({}, "f19", 0) end,
        },
        start = true,
    })

hs.spoons.use('IMLight', {
        config = {
            delay = 0.05,
            im_name = '搜狗拼音',
        },
        start = true,
    })

hs.spoons.use('DailySelfie', {
        config = {
            dir = "/Users/blahgeek/Documents/Selfie/",
            interval = 3600 * 6,
        },
        start = true,
    })

hs.hotkey.bind({'cmd', 'ctrl'}, 'V',
    function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
