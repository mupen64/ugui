local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local checked = true
local text = 'Hello World!'
local position = {x = 0, y = 0}
local value = 0.5
local items = {}
local index = 1
local num = 50
local num2 = -50

for i = 1, 100, 1 do
    items[#items + 1] = 'Item ' .. i
end

emu.atdrawd2d(function()
    begin_frame()

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
            text = tostring(index),
        }) then
        index = index + 1
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
        rectangle = {x = 20, y = 200, width = 150, height = 150},
        position = position,
    })

    index = ugui.listbox({
        uid = 40,
        rectangle = {x = 20, y = 300, width = 120, height = 200},
        items = items,
        selected_index = index,
    })
    value = ugui.scrollbar({
        uid = 45,
        rectangle = {x = 230, y = 10, width = 20, height = 300},
        value = value,
        ratio = 0.2,
    })
    value = ugui.scrollbar({
        uid = 46,
        rectangle = {x = 280, y = 10, width = 300, height = 20},
        value = value,
        ratio = 0.2,
    })
    index = ugui.combobox({
        uid = 50,
        rectangle = {x = 200, y = 300, width = 160, height = 23},
        items = items,
        selected_index = index,
    })
    ugui.joystick({
        uid = 55,
        rectangle = {x = 200, y = 350, width = 150, height = 150},
        position = {
            x = math.sin(os.clock() / 2) * 50,
            y = math.cos(os.clock() / 2) * 50,
        },
        styler_mixin = {
            joystick = {
                tip_size = 50,
            },
        },
    })
    ugui.joystick({
        uid = 56,
        rectangle = {x = 355, y = 350, width = 150, height = 150},
        position = {
            x = math.sin(os.clock() / 2) * 50,
            y = math.cos(os.clock() / 2) * 50,
        },
    })
    index = ugui.carrousel_button({
        uid = 60,
        rectangle = {x = 380, y = 300, width = 160, height = 23},
        items = items,
        selected_index = index,
    })

    num = ugui.numberbox({
        uid = 65,
        rectangle = {x = 350, y = 50, width = 160, height = 23},
        value = num,
        places = 4,
    })
    BreitbandGraphics.draw_text2({
        rectangle = {x = 515, y = 50, width = 999, height = 23},
        align_x = BreitbandGraphics.alignment.start,
        text = tostring(num),
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
    })
    num2 = ugui.numberbox({
        uid = 70,
        rectangle = {x = 350, y = 75, width = 160, height = 23},
        value = num2,
        places = 4,
        show_negative = true,
    })
    BreitbandGraphics.draw_text2({
        rectangle = {x = 515, y = 75, width = 999, height = 23},
        align_x = BreitbandGraphics.alignment.start,
        text = tostring(num2),
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
    })

    end_frame()
end)
