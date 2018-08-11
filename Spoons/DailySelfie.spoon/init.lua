--- === DailySelfie ===
---
--- Take a selfie everyday

local obj={}
obj.__index = obj

-- Metadata
obj.name = "DailySelfie"
obj.version = "0.1"
obj.author = "BlahGeek <i@blahgeek.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- DailySelfie.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('DailySelfie')

--- Some configuration parameter
obj.ffmpeg = '/opt/local/bin/ffmpeg'
obj.dir = '/tmp'
obj.interval = 24 * 3600


function obj:take_selfie(filename)
    self.logger.i("Taking selfie to", filename)
    local proc = hs.task.new(self.ffmpeg, nil,
        (function(_, _, _) return true end),
        {"-f", "avfoundation", "-video_size", "1280x720", "-framerate", "30",
         "-pixel_format", "yuyv422", "-i", "0:", "-frames:v", "1",
         "-y", filename})
    proc:start()
    proc:waitUntilExit()
    self.logger.i("...done")
end


function obj:on_awake()
    local nowtime = os.time()
    self.logger.i("On awake, now is", nowtime)
    local lasttime_f = io.open(self.dir .. ".lasttime")
    if lasttime_f ~= nil then
        local lasttime = lasttime_f:read("n")
        lasttime_f:close()
        if lasttime ~= nil and lasttime + self.interval > nowtime then
            self.logger.i("Skip this awake")
            return
        end
    end

    self.logger.i("Updating lasttime")
    lasttime_f = io.open(self.dir .. ".lasttime", "w")
    lasttime_f:write(nowtime)
    lasttime_f:close()

    self._timer = hs.timer.doAfter(3, function() self:take_selfie(self.dir .. nowtime .. ".jpg") end)
    self._timer:start()
end


function obj:start()
    self:stop()
    self._watcher = hs.caffeinate.watcher.new(
        function(event)
            if event == hs.caffeinate.watcher.screensDidWake then
                self:on_awake()
            end
        end)
    self._watcher:start()
end

function obj:stop()
    if self._watcher then
        self._watcher:stop()
    end
end

return obj
