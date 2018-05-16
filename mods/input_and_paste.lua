
-- Prompt for text input, then input it
-- useful for applications that cannot use input method

local M = {}

function M.input_and_paste()
    local old_app = hs.window.focusedWindow()

    hs.focus()
    local btn, text = hs.dialog.textPrompt("Enter text to paste", "", "", "OK", "Cancel")

    if old_app ~= nil then
        old_app:focus()
    end

    if btn == "OK" then
        hs.eventtap.keyStrokes(text)
    end
end

function M.init(options)
    hs.hotkey.bind(options.modkey, "P", M.input_and_paste)
    BIND("input_and_paste", "Prompt for input and Paste", M.input_and_paste)
end

return M
