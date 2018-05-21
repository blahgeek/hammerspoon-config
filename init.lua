-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2018-05-21

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

local config = require "config"

_MODS_TABLE = {}

for mod, opts in pairs(config) do
    _MODS_TABLE[mod] = require("mods." .. mod)
    _MODS_TABLE[mod].init(opts)
end

----------------

for k, v in pairs(_BIND_TABLE) do
    hs.urlevent.bind(k, v.fn)
end
