--- === IMLight ===
---
--- Turn on/off caps lock LED on specific input method
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/IMLight.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/IMLight.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "IMLight"
obj.version = "0.1"
obj.author = "BlahGeek <i@blahgeek.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- IMLight.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('IMLight')

--- Some configuration parameter
obj.im_name = '搜狗拼音'
obj.delay = 0.1

local setleds = hs.spoons.resource_path("setleds")

function obj:callback()
    local im = hs.keycodes.currentMethod()
    local args = {}
    if im == self.im_name then
        self.logger.i("Set LED on for " .. (im or "nil"))
        args = {"+caps"}
    else
        self.logger.i("Set LED off for " .. (im or "nil"))
        args = {"-caps"}
    end
    hs.task.new(setleds, nil, function(_,_,_) return false end, args):start()
end

function obj:start()
    self._timer = hs.timer.delayed.new(self.delay, function() self:callback() end)
    hs.keycodes.inputSourceChanged(function() self._timer:start() end)
end

return obj
