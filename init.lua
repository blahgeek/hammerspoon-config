-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-05-29

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

MODS = {
    "force_paste",
    "selfie",
    "yoink",
    "tunet",
}

_MODS_TABLE = {}

for _, v in pairs(MODS) do
    _MODS_TABLE[v] = require("mods." .. v)
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
