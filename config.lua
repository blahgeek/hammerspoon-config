-- @Author: BlahGeek
-- @Date:   2016-07-04
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-07-04


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
        keyword = '屏幕快照',
        dir = os.getenv("HOME") .. "/Desktop",
    },
}

return CONFIG
