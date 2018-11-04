local obj = {}
obj.__index = obj

obj.name = 'ChunkI3'
obj.version = '0.1'
obj.author = "BlahGeek <i@blahgeek.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.logger = hs.logger.new('ChunkI3')
obj._hotkeys = {}

obj.chunkc = '/usr/local/bin/chunkc'
obj.mod = {'ctrl', 'cmd'}
obj.mod_alt = {'ctrl', 'cmd', 'alt'}
obj.status_update_interval = 2

function obj:_bind(key, use_alt, cmd)
    local mod = self.mod
    if use_alt then
        mod = self.mod_alt
    end
    local h = hs.hotkey.bind(mod, key, function()
        local t = hs.task.new(self.chunkc, nil, cmd)
        t:start()
        t:waitUntilExit()
        self:_update_menu()
    end)
    table.insert(self._hotkeys, h)
end

obj._menu_desktop_id = ''
obj._menu_desktop_mode = ''

function obj:_do_update_menu()
    self._menu:setTitle(self._menu_desktop_id .. ':' .. self._menu_desktop_mode)
end

function obj:_update_menu()
    hs.task.new(self.chunkc, function(_, out, err)
        self._menu_desktop_id = out
        self:_do_update_menu()
    end, {'tiling::query', '--desktop', 'id'}):start()

    hs.task.new(self.chunkc, function(_, out, err)
        self._menu_desktop_mode = out
        self:_do_update_menu()
    end, {'tiling::query', '--desktop', 'mode'}):start()
end

function obj:start()
    self:_bind('f', false, {'tiling::window', '--toggle', 'fullscreen'})
    self:_bind('space', true, {'tiling::window', '--toggle', 'float'})
    self:_bind('q', true, {'tiling::window', '--close'})
    self:_bind('m', true, {'tiling::window', '--send-to-monitor', 'next'})
    self:_bind('m', false, {'tiling::monitor', '-f', 'next'})

    self:_bind('v', false, {'tiling::window', '--use-insertion-point', 'east'})
    self:_bind('n', false, {'tiling::window', '--use-insertion-point', 'south'})

    self:_bind('h', false, {'tiling::window', '--focus', 'west'})
    self:_bind('j', false, {'tiling::window', '--focus', 'south'})
    self:_bind('k', false, {'tiling::window', '--focus', 'north'})
    self:_bind('l', false, {'tiling::window', '--focus', 'east'})

    self:_bind('h', true, {'tiling::window', '--warp', 'west'})
    self:_bind('j', true, {'tiling::window', '--warp', 'south'})
    self:_bind('k', true, {'tiling::window', '--warp', 'north'})
    self:_bind('l', true, {'tiling::window', '--warp', 'east'})

    self:_bind('1', false, {'tiling::desktop', '--focus', '1'})
    self:_bind('2', false, {'tiling::desktop', '--focus', '2'})
    self:_bind('3', false, {'tiling::desktop', '--focus', '3'})
    self:_bind('4', false, {'tiling::desktop', '--focus', '4'})
    self:_bind('5', false, {'tiling::desktop', '--focus', '5'})
    self:_bind('6', false, {'tiling::desktop', '--focus', '6'})
    self:_bind('7', false, {'tiling::desktop', '--focus', '7'})
    self:_bind('8', false, {'tiling::desktop', '--focus', '8'})
    self:_bind('9', false, {'tiling::desktop', '--focus', '9'})
    self:_bind('0', false, {'tiling::desktop', '--focus', '10'})

    self:_bind('1', true, {'tiling::window', '--send-to-desktop', '1'})
    self:_bind('2', true, {'tiling::window', '--send-to-desktop', '2'})
    self:_bind('3', true, {'tiling::window', '--send-to-desktop', '3'})
    self:_bind('4', true, {'tiling::window', '--send-to-desktop', '4'})
    self:_bind('5', true, {'tiling::window', '--send-to-desktop', '5'})
    self:_bind('6', true, {'tiling::window', '--send-to-desktop', '6'})
    self:_bind('7', true, {'tiling::window', '--send-to-desktop', '7'})
    self:_bind('8', true, {'tiling::window', '--send-to-desktop', '8'})
    self:_bind('9', true, {'tiling::window', '--send-to-desktop', '9'})
    self:_bind('0', true, {'tiling::window', '--send-to-desktop', '10'})

    -- special hotkey: initialize
    local hotkey_initialize = hs.hotkey.bind(self.mod_alt, 'i', function()
        for i = 1,10 do
            hs.task.new(self.chunkc, nil, {'tiling::desktop', '--annihilate'}):start():waitUntilExit()
        end
        for i = 1,9 do
            hs.task.new(self.chunkc, nil, {'tiling::desktop', '--create'}):start():waitUntilExit()
        end
    end)
    table.insert(self._hotkeys, hotkey_initialize)

    -- special hotkey: terminal
    local hotkey_terminal = hs.hotkey.bind(self.mod, 'return', function()
        hs.osascript.applescript('tell application "iTerm"\n' ..
            'create window with default profile\n' ..
            'end tell')
    end)
    table.insert(self._hotkeys, hotkey_terminal)

    self._menu = hs.menubar.new()
    self:_update_menu()
    self._timer = hs.timer.doEvery(self.status_update_interval,
        function() self:_update_menu() end)
end

function obj:stop()
    for _, h in pairs(self._hotkeys) do
        h:delete()
    end
    self._hotkeys = {}
    self._timer:stop()
end

return obj
