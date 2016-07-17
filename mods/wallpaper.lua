-- @Author: BlahGeek
-- @Date:   2016-07-17
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-07-17


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

    M.timer = hs.timer.new(options.interval, M.find_and_set)
    M.timer:start()
end

return M
