-- @Author: BlahGeek
-- @Date:   2016-07-17
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-07-20


local M = {}

M.log = hs.logger.new('wallpaper', 'info')

local function set_wallpaper(filename)
    M.log.i("Setting wallpaper to", filename)
    local ok, _, msg = hs.applescript("tell application \"System Events\" " ..
                   "to set picture of every desktop to " ..
                   "(\"" .. filename .. "\" as POSIX file as alias)")
end

function M.find_and_set()
    M.log.i("Trying to update wallpaper from", M.DIR)
    local f, d = hs.fs.dir(M.DIR)
    local filename = nil
    while true do
        local new_filename = f(d)
        if new_filename == nil then break end
        filename = new_filename
    end
    if filename ~= nil and string.find(filename, '.png$') ~= nil then
        set_wallpaper(M.DIR .. filename)
    end
end

function M.init(options)
    M.DIR = options.dir
    BIND("wallpaper", "Update Wallpaper", M.find_and_set)

    M.space_watcher = hs.spaces.watcher.new((function(space_n)
        if M.timer ~= nil and M.timer:running() then
            M.timer:stop()
            M.timer = nil
        end
        M.timer = hs.timer.doAfter(3, M.find_and_set)
    end))
    M.space_watcher:start()

    M.find_and_set()
end

return M
