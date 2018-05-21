-- @Author: BlahGeek
-- @Date:   2016-07-04
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2018-05-21

local modkey = {"cmd", "alt", "ctrl", "shift"}

local config = {
    force_paste = {
        modkey = modkey,
    },
    input_and_paste = {
        modkey = modkey,
    },
    selfie = {
        dir = "/Users/blahgeek/Documents/Selfie/",
        interval = 3600 * 6,
    },
    drop = {
        tag = '灰色',
        app = 'Dropshelf',
        keyword = 'Screen Shot',
        dir = os.getenv("HOME") .. "/Desktop",
    },
    imswitch = {},
    -- caps_remap = {
    --     timeout = 0.15,
    --     key = "ctrl",
    --     action = function() hs.eventtap.keyStroke({}, "f19") end,
    -- },
    -- imlight = {
    --     setleds = '/Users/BlahGeek/.local/bin/setleds',
    --     delay = 0.05,
    -- },
    -- wallpaper = {
    --     dir = '/Users/BlahGeek/Sync/himawari/',
    --     interval = 60 * 10,
    -- },
}

return config
