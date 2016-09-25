-- @Author: BlahGeek
-- @Date:   2016-09-21
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-09-22

local M = {}

local events = hs.eventtap.event.types


M.log = hs.logger.new('caps_remap', 'info')


M.last_flags_1 = {}
M.last_flags_0 = {}
M.last_time_1 = 0
M.last_time_0 = 0

M.timeout = 0.2
M.key = "ctrl"
M.action = nil

local function _dict_has_no_other_key(dic)
    for k,v in pairs(dic) do
        if k ~= M.key then
            return false
        end
    end
    return true
end

function M.event_callback(e)
    local typ = e:getType()
    local code = e:getKeyCode()
    local flags = e:getFlags()
    local now = hs.timer.secondsSinceEpoch()

    if _dict_has_no_other_key(flags) and not flags[M.key]
        and _dict_has_no_other_key(M.last_flags_0) and M.last_flags_0[M.key]
        and _dict_has_no_other_key(M.last_flags_1) and not M.last_flags_1[M.key]
        and now - M.last_time_0 < M.timeout
        then
        M.log.i("Fire caps action")
        if M.action then
            M.action()
        end
    end

    M.last_flags_1 = M.last_flags_0
    M.last_flags_0 = flags

    M.last_time_1 = M.last_time_0
    M.last_time_0 = now

    return false
end


function M.init(options)
    if options.key then
        M.key = options.key
    end
    if options.timeout then
        M.timeout = options.timeout
    end
    if options.action then
        M.action = options.action
    end
    M.watcher = hs.eventtap.new({events.flagsChanged}, M.event_callback)
    M.watcher:start()
end

return M

