-- @Author: BlahGeek
-- @Date:   2016-05-29
-- @Last Modified by:   BlahGeek
-- @Last Modified time: 2016-07-04


local M = {}

local LOGIN_URL = "http://net.tsinghua.edu.cn/do_login.php"
local LOGIN_UA = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4)'

local LOGO = '/Users/BlahGeek/.hammerspoon/mods/images/tunet.png'

M.log = hs.logger.new('tunet', 'info')

M.ERRORS = {
    [3001]= "Quota outage",
    [3004]= "Insufficient balance",
    [2616]= "Insufficient balance",
    [2531]= "User does not exist",
    [2532]= "Too fast",
    [2533]= "Too much times",
    [2553]= "Wrong password",
    [2620]= "Already online",
    [2840]= "Internal address",
    [2842]= "Authorization not required",
}

M.login_callback_parse = function(code, msg)
    if code ~= 200 then
        return false, string.format("HTTP Error: %d", code)
    end
    if string.find(msg, "successful") or string.find(msg, "has been online") then
        return true, msg
    end
    local error_code = tonumber(string.find(msg, "[0-9]+"))
    local error_str = M.ERRORS[error_code]
    if error_str ~= nil then
        return false, error_str
    end
    return false, "Unknown error"
end

M.login_callback = function(code, body, _)
    M.log.i(string.format("Login callback: %d, %s", code, body))
    local success, msg = M.login_callback_parse(code, body)
    local title = "Login success"
    if not success then
        title = "Login failed"
    end

    local noti = hs.notify.new(nil, {
        title = "Tunet Auto Login",
        subTitle = title,
        informativeText = msg,
    })
    noti:setIdImage(hs.image.imageFromPath(LOGO))
    noti:send()
end

M.do_login = function()
    M.log.i("Do login...")
    hs.http.asyncPost(LOGIN_URL,
                      string.format("username=%s&password=%s&ac_id=1&action=login",
                                    M.USERNAME, M.PASSWD),
                      { ['User-Agent'] = LOGIN_UA }, M.login_callback)
end

M.init = function(options)
    M.USERNAME = options.username
    M.PASSWD = options.passwd
    if options.enable_watcher then
        M.network_watcher = hs.network.reachability.forAddress('166.111.204.120')
        M.network_watcher:setCallback(function(self, flags)
            if (flags & hs.network.reachability.flags.reachable) > 0 then
                M.do_login()
            end
        end)
        M.network_watcher:start()
    end
    BIND("tunet_login", "Tunet Login", M.do_login)
end

return M
