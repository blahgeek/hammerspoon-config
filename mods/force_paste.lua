-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2018-05-16

local M = {}

function M.force_paste()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end

function M.init(options)
    hs.hotkey.bind(options.modkey, "V", M.force_paste)
    BIND("force_paste", "Force Paste", M.force_paste)
end

return M
