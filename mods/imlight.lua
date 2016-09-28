-- @Author: BlahGeek
-- @Date:   2016-09-28
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-09-28

local M = {}

M.logger = hs.logger.new('IMLight', 'info')

M.im_name = '搜狗拼音'
M.setleds = 'setleds'
M.delay = 0.1


function M.callback()
    local im = hs.keycodes.currentMethod()
    local args = {}
    if im == M.im_name then
        M.logger.i("Set LED on for " .. (im or "nil"))
        args = {"+caps"}
    else
        M.logger.i("Set LED off for " .. (im or "nil"))
        args = {"-caps"}
    end
    hs.task.new(M.setleds, nil,
                function(_,_,_) return false end,
                args):start()
end


function M.init(options)
    if options.im_name then
        M.im_name = options.im_name
    end
    if options.setleds then
        M.setleds = options.setleds
    end

    M.timer = hs.timer.delayed.new(M.delay, M.callback)
    hs.keycodes.inputSourceChanged(function()
                                       M.timer:start()
                                   end)
end


return M
