-- @Author: BlahGeek
-- @Date:   2016-04-23
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-07-04

local M = {}

local IMAGESNAP = "/usr/local/bin/imagesnap"

M.log = hs.logger.new('selfie', 'info')

local function take_selfie(filename)
    M.log.i("Taking selfie to", filename)
    local proc = hs.task.new(IMAGESNAP, nil,
                             (function(_, _, _) return true end),
                             {"-w", "1", filename})
    proc:start()
    proc:waitUntilExit()
    M.log.i("...done")
end

local function on_awake(dir, interval)
    local nowtime = os.time()
    M.log.i("On awake, now is", nowtime)
    local lasttime_f = io.open(dir .. ".lasttime")
    if lasttime_f ~= nil then
        local lasttime = lasttime_f:read("n")
        lasttime_f:close()
        if lasttime ~= nil and lasttime + interval > nowtime then
            M.log.i("Skip this awake")
            return
        end
    end

    M.log.i("Updating lasttime")
    lasttime_f = io.open(dir .. ".lasttime", "w")
    lasttime_f:write(nowtime)
    lasttime_f:close()

    M.timer = hs.timer.doAfter(3, function() take_selfie(dir .. nowtime .. ".jpg") end)
    M.timer:start()
end

function M.init(options)
    M.watcher = hs.caffeinate.watcher.new(function(event)
                                              if event ~= hs.caffeinate.watcher.screensDidWake then
                                                  return
                                              end
                                              on_awake(options.dir, options.interval)
                                          end)
    M.watcher:start()
end

return M
