-- @Author: BlahGeek
-- @Date:   2016-04-29
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-05-29

local M = {}

M.MARK_TAG = '灰色'
M.FILENAME_KEYWORD = '屏幕快照'
M.WATCH_DIR = os.getenv("HOME") .. "/Desktop"

M.log = hs.logger.new('yoink', 'info')

function M.send_to_yoink(filepath)
    local proc = hs.task.new("/usr/bin/open", nil, (function(_,_,_) return true end),
                             {"-a", "Yoink", filepath})
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
        M.log.i("Sending to yoink: " .. filepath)
        M.send_to_yoink(filepath)
        hs.fs.tagsAdd(filepath, {M.MARK_TAG, })
    end
end

M.watcher = hs.pathwatcher.new(M.WATCH_DIR, M.send_latest)
M.watcher:start()
