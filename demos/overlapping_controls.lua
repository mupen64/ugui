local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\')

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

---@module "mupen-lua-ugui-ext"
ugui_ext = dofile(path_root .. 'mupen-lua-ugui-ext.lua')

local checked = true
local text = 'Hello World!'
local position = {x = 0, y = 0}
local value = 0.5
local items = {'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item', 'Item'}
local index = 1

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
            uid = 5,
            rectangle = {x = 10, y = 10, width = 200, height = 400},
            text = 'Hello, world!',
        }) then
        print('1')
    end
    if ugui.button({
            uid = 10,
            rectangle = {x = 80, y = 80, width = 100, height = 50},
            text = 'Hello, world!',
        }) then
        print('2')
    end
    if ugui.button({
            uid = 15,
            rectangle = {x = 80, y = 140, width = 100, height = 30},
            text = 'Hello, world!',
            is_enabled = false,
        }) then
        print('3')
    end
    checked = ugui.toggle_button({
        uid = 20,
        rectangle = {x = 80, y = 200, width = 200, height = 50},
        text = 'Hello, world!',
        is_checked = checked,
    })
    text = ugui.textbox({
        uid = 25,
        rectangle = {x = 20, y = 20, width = 100, height = 20},
        text = text,
    })
    position = ugui.joystick({
        uid = 30,
        rectangle = {x = 20, y = 200, width = 50, height = 50},
        position = position,
    })
    -- value = ugui.trackbar({
    --     uid = 7,
    --     rectangle = {x = 20, y = 260, width = 120, height = 20},
    --     value = value,
    -- })
    index = ugui.listbox({
        uid = 35,
        rectangle = {x = 20, y = 300, width = 120, height = 200},
        items = items,
        selected_index = index,
    })
    value = ugui.scrollbar({
        uid = 40,
        rectangle = {x = 230, y = 10, width = 20, height = 300},
        value = value,
        ratio = 0.2,
    })

    ugui.end_frame()
end)
