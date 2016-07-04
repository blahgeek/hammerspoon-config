-- @Author: BlahGeek
-- @Date:   2016-04-29
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-07-04

local M = {}

M.log = hs.logger.new('drop', 'info')

function M.send_to_drop(filepath)
    local proc = hs.task.new("/usr/bin/open", nil, (function(_,_,_) return true end),
                             {"-a", M.APP, filepath})
    proc:start()
    proc:waitUntilExit()
end

function M.send_latest()
    local f, d = hs.fs.dir(M.WATCH_DIR)
    local filename = nil
    local target_filepaths = {}
    while true do
        filename = f(d)
        if filename == nil then break end
        local filepath = M.WATCH_DIR .. "/" .. filename
        local tags = hs.fs.tagsGet(filepath)

        if string.find(filename, M.FILENAME_KEYWORD) == 1 and (tags == nil or #tags == 0) then
            table.insert(target_filepaths, filepath)
        end
    end

    for _, filepath in pairs(target_filepaths) do
        M.log.i("Sending to drop: " .. filepath)
        M.send_to_drop(filepath)
        hs.fs.tagsAdd(filepath, {M.MARK_TAG, })
    end
end

function M.init(options)
    M.MARK_TAG = options.tag
    M.FILENAME_KEYWORD = options.keyword
    M.APP = options.app
    M.WATCH_DIR = options.dir

    M.watcher = hs.pathwatcher.new(options.dir, M.send_latest)
    M.watcher:start()
end

return M
