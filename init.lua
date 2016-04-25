-- @Author: BlahGeek
-- @Date:   2016-02-18
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-04-25

local watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/mods/", 
                                   (function(files)
                                        hs.reload()
                                        hs.notify.show("HammerSpoon", "", "Config reloaded", "")
                                    end))
watcher:start()

require("mods.force_paste")
require("mods.selfie")

