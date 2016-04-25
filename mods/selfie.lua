-- @Author: BlahGeek
-- @Date:   2016-04-23
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-04-25

local IMAGESNAP = "/usr/local/bin/imagesnap"
local SELFIE_DIR = "/Users/BlahGeek/Pictures/selfie/"
local SELFIE_MIN_INTERVAL = 3600 * 6

local log = hs.logger.new('selfie', 'info')

function take_selfie(filename)
    log.i("Taking selfie to", filename)
    local proc = hs.task.new(IMAGESNAP, nil, 
                             (function(_, _, _) return true end), 
                             {"-w", "1", filename})
    proc:start()
    proc:waitUntilExit()
    log.i("...done")
end

function on_awake()
    local nowtime = os.time()
    log.i("On awake, now is", nowtime)
    local lasttime_f = io.open(SELFIE_DIR .. ".lasttime")
    if lasttime_f ~= nil then
        local lasttime = lasttime_f:read("n")
        lasttime_f:close()
        if lasttime ~= nil and lasttime + SELFIE_MIN_INTERVAL > nowtime then
            log.i("Skip this awake")
            return
        end
    end

    log.i("Updating lasttime")
    lasttime_f = io.open(SELFIE_DIR .. ".lasttime", "w")
    lasttime_f:write(nowtime)
    lasttime_f:close()

    local timer = hs.timer.doAfter(3, function() take_selfie(SELFIE_DIR .. nowtime .. ".jpg") end)
    timer:start()
end

local watcher = hs.caffeinate.watcher.new(function(event)
                                              if event ~= hs.caffeinate.watcher.screensDidWake then
                                                  return
                                              end
                                              on_awake()
                                          end)
watcher:start()
