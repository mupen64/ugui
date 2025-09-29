local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local pages = {}
local selected_page_index = 1
local is_joystick_enabled = true

pages[1] = function()
    ugui.button({
        uid = 0,

        rectangle = {
            x = 5,
            y = 100,
            width = 120,
            height = 30,
        },
        text = 'Do something',
    })
end

pages[2] = function()
    ugui.joystick({
        uid = 1,
        is_enabled = is_joystick_enabled,
        rectangle = {
            x = 5,
            y = 100,
            width = 100,
            height = 100,
        },
        position = {
            x = (math.sin(os.clock() * 2) + 1) / 2,
            y = (math.cos(os.clock() * 2) + 1) / 2,
        },
        mag = 0,
    })

    is_joystick_enabled = ugui.toggle_button({
        uid = 2,

        rectangle = {
            x = 5,
            y = 230,
            width = 100,
            height = 30,
        },
        text = 'Joystick',
        is_checked = is_joystick_enabled,
    })
end

emu.atdrawd2d(function()
    begin_frame()

    local items = {}

    for i = 1, #pages, 1 do
        items[i] = 'Page Nr. ' .. i
    end

    selected_page_index = ugui.combobox({
        uid = 6000,

        rectangle = {
            x = 5,
            y = 10,
            width = 80,
            height = 20,
        },
        items = items,
        selected_index = selected_page_index,
    })

    selected_page_index = ugui.carrousel_button({
        uid = 60001,

        rectangle = {
            x = 5,
            y = 40,
            width = 190,
            height = 20,
        },
        items = items,
        selected_index = selected_page_index,
    })

    pages[selected_page_index]()

    end_frame()
end)
