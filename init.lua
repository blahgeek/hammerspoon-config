-- Hammerspoon configuration

local appMappings = {
    e = "org.gnu.Emacs",
    s = "org.mozilla.firefox",
    f = "com.electron.lark"
}

for key, bundleId in pairs(appMappings) do
    hs.hotkey.bind({"alt"}, key, function()
        hs.application.launchOrFocusByBundleID(bundleId)
    end)
end
