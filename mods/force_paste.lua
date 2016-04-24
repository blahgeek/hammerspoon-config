-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-02-18

function force_paste()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end

hs.hotkey.bind({"cmd", "alt"}, "V", force_paste)
hs.urlevent.bind("force_paste", force_paste)
