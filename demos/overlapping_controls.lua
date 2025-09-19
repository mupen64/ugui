local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\')

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

---@module "mupen-lua-ugui-ext"
ugui_ext = dofile(path_root .. 'mupen-lua-ugui-ext.lua')

local checked = true

emu.atdrawd2d(function()
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
        wheel = 0,
        is_primary_down = keys.leftclick,
        held_keys = keys,
    })
    if ugui.button({
            uid = 1,
            rectangle = {x = 10, y = 10, width = 200, height = 300},
            text = 'Hello, world!',
        }) then
        print('1')
    end
    if ugui.button({
            uid = 2,
            rectangle = {x = 80, y = 80, width = 100, height = 50},
            text = 'Hello, world!',
        }) then
        print('2')
    end
    if ugui.button({
            uid = 3,
            rectangle = {x = 80, y = 140, width = 100, height = 30},
            text = 'Hello, world!',
            is_enabled = false,
        }) then
        print('3')
    end
    checked = ugui.toggle_button({
        uid = 4,
        rectangle = {x = 80, y = 200, width = 200, height = 50},
        text = 'Hello, world!',
        is_checked = checked,
    })

    

    ugui.end_frame()
end)
