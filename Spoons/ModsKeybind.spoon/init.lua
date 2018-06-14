--- === ModsKeybind ===
---
--- Bind single modkey press (e.g. ctrl, alt, cmd) to certain action

local obj={}
obj.__index = obj

local events = hs.eventtap.event.types

-- Metadata
obj.name = "ModsKeybind"
obj.version = "0.1"
obj.author = "BlahGeek <i@blahgeek.com"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- ModsKeybind.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('ModsKeybind')

--- Some internal variable
obj.last_flags_1 = {}
obj.last_flags_0 = {}
obj.last_time_1 = 0
obj.last_time_0 = 0

--- Some configuration parameter
--- Keypress timeout
obj.timeout = 0.15
--- Mod key to bind
obj.key = "ctrl"
--- Action
obj.action = nil

local function _dict_has_no_other_key(dic, key)
    for k,v in pairs(dic) do
        if k ~= key then
            return false
        end
    end
    return true
end

function obj:event_callback(e)
    local typ = e:getType()
    local code = e:getKeyCode()
    local flags = e:getFlags()
    local now = hs.timer.secondsSinceEpoch()

    if _dict_has_no_other_key(flags, self.key) and not flags[self.key]
        and _dict_has_no_other_key(self.last_flags_0, self.key) and self.last_flags_0[self.key]
        and _dict_has_no_other_key(self.last_flags_1, self.key) and not self.last_flags_1[self.key]
        and now - self.last_time_0 < self.timeout
        then
        self.logger.i("Fire action")
        if self.action then
            self.action()
        end
    end

    self.last_flags_1 = self.last_flags_0
    self.last_flags_0 = flags

    self.last_time_1 = self.last_time_0
    self.last_time_0 = now

    return false
end

function obj:start()
    self:stop()
    self._watcher = hs.eventtap.new({events.flagsChanged}, function(...) self:event_callback(...) end)
    self._watcher:start()
end

function obj:stop()
    if self._watcher then
        self._watcher:stop()
    end
end

return obj
