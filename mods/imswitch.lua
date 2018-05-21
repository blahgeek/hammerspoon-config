local M = {}

M.logger = hs.logger.new('IMSwitch', 'info')

function M.imswitch(eventName, params)
    local layout = params['layout']
    local method = params['method']

    if layout ~= nil then
        hs.keycodes.setLayout(layout)
    end

    if method ~= nil then
        hs.keycodes.setMethod(method)
    end

    return {
        layout = hs.keycodes.currentLayout(),
        method = hs.keycodes.currentMethod(),
    }
end

function M.init(options)
    BIND("imswitch", "Input Method Switch", M.imswitch)
end

return M
