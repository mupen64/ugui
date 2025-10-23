local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\')
local test_root = debug.getinfo(1).short_src:gsub('(\\[^\\]+)\\[^\\]+$', '%1\\')

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

---@module "mupen-lua-ugui-ext"
ugui_ext = dofile(path_root .. 'mupen-lua-ugui-ext.lua')

function begin_frame()
    local window_size = wgui.info()

    BreitbandGraphics.fill_rectangle({
        x = 0,
        y = 0,
        width = window_size.width,
        height = window_size.height,
    }, {
        r = 253,
        g = 253,
        b = 253,
    })

    local keys = input.get()
    ugui.begin_frame({
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
        window_size = {
            x = window_size.width,
            y = window_size.height - 23,
        },
    })
    mouse_wheel = 0
end

function end_frame()
    ugui.end_frame()
end

emu.atwindowmessage(function(_, msg_id, wparam, _)
    if msg_id == 522 then
        local scroll = math.floor(wparam / 65536)
        if scroll == 120 then
            mouse_wheel = 1
        elseif scroll == 65416 then
            mouse_wheel = -1
        end
    end
end)
