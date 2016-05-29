-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-05-29

local M = {}

function M.force_paste()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end

hs.hotkey.bind({"cmd", "alt"}, "V", M.force_paste)
BIND("force_paste", "Force Paste", M.force_paste)

return M
