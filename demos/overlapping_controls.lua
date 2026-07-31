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
            uid = 100,
            margin = '10px 10px',
            size = '600px 400px',
            text = 'Hello, world!',
        }) then
        print('1')
    end
    if ugui.button({
            uid = 200,
            margin = (80 + math.sin(os.clock() * 5) * 10) .. 'px ' .. (80 + math.cos(os.clock() * 5) * 10) .. 'px',
            size = '100px 50px',
            text = tostring(index),
        }, function()
            ugui.button({
                uid = 300,
                margin = '10px 10px',
                size = '20px 20px',
                text = '😀',
            })
        end) then
        index = index + 1
    end
    if ugui.button({
            uid = 400,
            margin = '80px 140px',
            size = '100px 30px',
            text = 'Hello, world!',
            is_enabled = false,
        }) then
        print('3')
    end
    checked = ugui.toggle_button({
        uid = 500,
        margin = '80px 200px',
        size = '200px 50px',
        text = 'Hello, world!',
        is_checked = checked,
    })
    text = ugui.textbox({
        uid = 600,
        margin = '20px 20px',
        size = '100px 20px',
        text = text,
    })
    position = ugui.joystick({
        uid = 700,
        margin = '20px 200px',
        size = '150px 150px',
        position = position,
    })

    index = ugui.listbox({
        uid = 800,
        margin = '20px 300px',
        size = '120px 200px',
        items = items,
        selected_index = index,
    })
    value = ugui.scrollbar({
        uid = 900,
        margin = '230px 10px',
        size = '20px 300px',
        value = value,
        ratio = 0.2,
    })
    value = ugui.scrollbar({
        uid = 1000,
        margin = '280px 10px',
        size = '300px 20px',
        value = value,
        ratio = 0.2,
    })
    index = ugui.combobox({
        uid = 1100,
        margin = '200px 300px',
        size = '160px 23px',
        items = items,
        selected_index = index,
    })
    ugui.joystick({
        uid = 1200,
        margin = '200px 350px',
        size = '150px 150px',
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
        uid = 1300,
        margin = '355px 350px',
        size = '150px 150px',
        position = {
            x = math.sin(os.clock() / 2) * 50,
            y = math.cos(os.clock() / 2) * 50,
        },
    })
    index = ugui.carrousel_button({
        uid = 1400,
        margin = '380px 300px',
        size = '160px 23px',
        items = items,
        selected_index = index,
    })

    num = ugui.numberbox({
        uid = 1500,
        margin = '350px 50px',
        size = '160px 23px',
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
        uid = 1600,
        margin = '350px 75px',
        size = '160px 23px',
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
        uid = 1700,
        margin = '350px 150px',
        size = '160px 23px',
        text = 'Hello World!',
        color = BreitbandGraphics.colors.black,
        font_name = 'Wingdings',
        font_size = 24,
    })
    ugui.label({
        uid = 1800,
        margin = '350px 180px',
        size = '160px 23px',
        text = 'Hello World!',
        color = BreitbandGraphics.colors.black,
        font_name = 'Consolas',
        font_size = 24,
        hittestable = true,
    })
    index = ugui.combobox({
        uid = 1900,
        margin = '350px 230px',
        size = '160px 23px',
        items = items,
        selected_index = index,
        editable = true,
    })
    ugui.listbox({
        uid = 2000,
        margin = '560px 230px',
        size = '160px 160px',
        items = {},
        selected_index = 1,
    })
    ugui.listbox({
        uid = 2100,
        margin = '560px 360px',
        size = '160px 160px',
        items = {'a'},
        selected_index = nil,
    })
    if ugui.button({
            uid = 2200,
            margin = '620px 10px',
            size = '200px 200px',
            text = '',
        }, function()
            ugui.button({
                uid = 2300,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'top left',
            })
            ugui.button({
                uid = 2400,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'top center',
                align = '0.5 0',
            })
            ugui.button({
                uid = 2500,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'top right',
                align = '1 0',
            })
            ugui.button({
                uid = 2600,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'bottom left',
                align = '0 1',
            })
            ugui.button({
                uid = 2700,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'bottom center',
                align = '0.5 1',
            })
            ugui.button({
                uid = 2800,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'bottom right',
                align = '1 1',
            })
            ugui.button({
                uid = 2900,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'left center',
                align = '0 0.5',
            })
            ugui.button({
                uid = 3000,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'right center',
                align = '1 0.5',
            })
            ugui.button({
                uid = 3100,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'center',
                align = '0.5',
            })
            ugui.button({
                uid = 3200,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'smooth',
                align = (math.sin(os.clock() * 2) + 1) / 2 .. ' ' .. (math.cos(os.clock() * 2) + 1) / 2,
            })
        end) then
        index = index + 1
    end
    if ugui.button({
            uid = 3300,
            margin = '650px 220px',
            size = '200px',
            text = '',
            is_enabled = false,
        }, function()
            ugui.button({
                uid = 3400,
                text = 'half width',
                size = '0.5 23px',
            })
            ugui.button({
                uid = 3500,
                text = 'half\nheight',
                size = '23px 0.5',
                align = '0.5 1',
            })
        end) then
        index = index + 1
    end
    end_frame()
end)
