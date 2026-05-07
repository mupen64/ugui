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

ugui.DEBUG = true

emu.atdrawd2d(function()
    begin_frame()

    if ugui.button({
            uid = 5,
            rectangle = {x = 10, y = 10, width = 600, height = 400},
            text = 'Hello, world!',
        }) then
        print('1')
    end
    if ugui.button({
            uid = 15,
            rectangle = {x = 80 + math.sin(os.clock() * 5) * 10, y = 80 + math.cos(os.clock() * 5) * 10, width = 100, height = 50},
            text = tostring(index),
        }, function()
            ugui.button({
                uid = 999999,
                rectangle = {x = 10, y = 10, width = 20, height = 20},
                text = '😀',
            })
        end) then
        index = index + 1
    end
    if ugui.button({
            uid = 25,
            rectangle = {x = 80, y = 140, width = 100, height = 30},
            text = 'Hello, world!',
            is_enabled = false,
        }) then
        print('3')
    end
    checked = ugui.toggle_button({
        uid = 35,
        rectangle = {x = 80, y = 200, width = 200, height = 50},
        text = 'Hello, world!',
        is_checked = checked,
    })
    text = ugui.textbox({
        uid = 45,
        rectangle = {x = 20, y = 20, width = 100, height = 20},
        text = text,
    })
    position = ugui.joystick({
        uid = 55,
        rectangle = {x = 20, y = 200, width = 150, height = 150},
        position = position,
    })

    index = ugui.listbox({
        uid = 65,
        rectangle = {x = 20, y = 300, width = 120, height = 200},
        items = items,
        selected_index = index,
    })
    value = ugui.scrollbar({
        uid = 75,
        rectangle = {x = 230, y = 10, width = 20, height = 300},
        value = value,
        ratio = 0.2,
    })
    value = ugui.scrollbar({
        uid = 85,
        rectangle = {x = 280, y = 10, width = 300, height = 20},
        value = value,
        ratio = 0.2,
    })
    index = ugui.combobox({
        uid = 95,
        rectangle = {x = 200, y = 300, width = 160, height = 23},
        items = items,
        selected_index = index,
    })
    ugui.joystick({
        uid = 105,
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
        uid = 115,
        rectangle = {x = 355, y = 350, width = 150, height = 150},
        position = {
            x = math.sin(os.clock() / 2) * 50,
            y = math.cos(os.clock() / 2) * 50,
        },
    })
    index = ugui.carrousel_button({
        uid = 125,
        rectangle = {x = 380, y = 300, width = 160, height = 23},
        items = items,
        selected_index = index,
    })

    num = ugui.numberbox({
        uid = 135,
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
        uid = 145,
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
    ugui.label({
        uid = 155,
        rectangle = {x = 350, y = 150, width = 160, height = 23},
        text = 'Hello World!',
        color = BreitbandGraphics.colors.black,
        font_name = 'Wingdings',
        font_size = 24,
    })
    ugui.label({
        uid = 165,
        rectangle = {x = 350, y = 180, width = 160, height = 23},
        text = 'Hello World!',
        color = BreitbandGraphics.colors.black,
        font_name = 'Consolas',
        font_size = 24,
        hittestable = true,
    })
    index = ugui.combobox({
        uid = 175,
        rectangle = {x = 350, y = 230, width = 160, height = 23},
        items = items,
        selected_index = index,
        editable = true,
    })
    ugui.listbox({
        uid = 185,
        rectangle = {x = 560, y = 230, width = 160, height = 160},
        items = {},
        selected_index = 1,
    })
    ugui.listbox({
        uid = 195,
        rectangle = {x = 560, y = 360, width = 160, height = 160},
        items = {'a'},
        selected_index = nil,
    })
    if ugui.button({
            uid = 210,
            rectangle = {x = 620, y = 10, width = 200, height = 200},
            text = '',
        }, function()
            ugui.button({
                uid = 220,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'top left',
            })
            ugui.button({
                uid = 230,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'top center',
                x_align = 0.5,
            })
            ugui.button({
                uid = 240,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'top right',
                x_align = 1,
            })
            ugui.button({
                uid = 250,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'bottom left',
                y_align = 1,
            })
            ugui.button({
                uid = 260,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'bottom center',
                x_align = 0.5,
                y_align = 1,
            })
            ugui.button({
                uid = 270,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'bottom right',
                x_align = 1,
                y_align = 1,
            })
            ugui.button({
                uid = 280,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'left center',
                y_align = 0.5,
            })
            ugui.button({
                uid = 290,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'right center',
                x_align = 1,
                y_align = 0.5,
            })
            ugui.button({
                uid = 300,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'center',
                x_align = 0.5,
                y_align = 0.5,
            })
            ugui.button({
                uid = 310,
                rectangle = {x = 0, y = 0, width = 50, height = 23},
                text = 'smooth',
                x_align = (math.sin(os.clock() * 2) + 1) / 2,
                y_align = (math.cos(os.clock() * 2) + 1) / 2,
            })
        end) then
        index = index + 1
    end
    if ugui.button({
            uid = 320,
            margin = '650px 220px',
            size = '200px',
            text = '',
            is_enabled = false
        }, function()
            ugui.button({
                uid = 330,
                text = 'half width',
                size = '50% 23px',
            })
            ugui.button({
                uid = 340,
                text = 'half\nheight',
                size = '23px 50%',
                x_align = 0.5,
                y_align = 1,
            })
        end) then
        index = index + 1
    end
    end_frame()
end)
