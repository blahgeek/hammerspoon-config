-- @Author: BlahGeek
-- @Date:   2016-07-04
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-09-22


CONFIG = {
    tunet = {
        enable_watcher = false,
        username = "zhaoyk15",
        passwd = "{MD5_HEX}" .. hs.settings.get("TUNET_PASSWD"),
    },
    force_paste = {},
    selfie = {
        dir = "/Users/BlahGeek/Archive/Selfie/",
        interval = 3600 * 6,
    },
    drop = {
        tag = '灰色',
        app = 'Dropshelf',
        keyword = 'Screen Shot',
        dir = os.getenv("HOME") .. "/Desktop",
    },
    caps_remap = {
        timeout = 0.15,
        key = "ctrl",
        action = function() hs.eventtap.keyStroke({}, "f19") end,
    },
    -- wallpaper = {
    --     dir = '/Users/BlahGeek/Sync/himawari/',
    --     interval = 60 * 10,
    -- },
}

return CONFIG
