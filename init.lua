-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-07-04

-- watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/",
--                              (function(files)
--                                   hs.reload()
--                                   hs.notify.show("HammerSpoon", "", "Config reloaded", "")
--                               end))
-- watcher:start()
--

_BIND_TABLE = {}

BIND = function(id, name, fn)
    _BIND_TABLE[id] = {name = name, fn = fn}
end

----------------

CONFIG = require "config"

_MODS_TABLE = {}

for mod, opts in pairs(CONFIG) do
    _MODS_TABLE[mod] = require("mods." .. mod)
    _MODS_TABLE[mod].init(opts)
end

----------------

for k, v in pairs(_BIND_TABLE) do
    hs.urlevent.bind(k, v.fn)
end

hs.ipc.handler = function(cmd)
    local action = _BIND_TABLE[cmd]
    if action ~= nil then
        return action.fn()
    end
    local ret = {}
    for k, v in pairs(_BIND_TABLE) do
        ret[k] = v.name
    end
    return hs.json.encode(ret)
end
