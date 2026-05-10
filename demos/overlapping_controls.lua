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

-- ugui.DEBUG = true

emu.atdrawd2d(function()
    begin_frame()

    if ugui.control({
            uid = 5,
            margin = '10px 10px',
            size = '600px 400px',
            text = 'Hello, world!',
        }, 'button').primary then
        print('1')
    end
    if ugui.control({
            uid = 15,
            margin = (80 + math.sin(os.clock() * 5) * 10) .. 'px ' .. (80 + math.cos(os.clock() * 5) * 10) .. 'px',
            size = '100px 50px',
            text = tostring(index),
        }, 'button', function()
            ugui.control({
                uid = 999999,
                margin = '10px 10px',
                size = '20px 20px',
                text = '😀',
            }, 'button')
        end).primary then
        index = index + 1
    end
    if ugui.button({
            uid = 25,
            margin = '80px 140px',
            size = '100px 30px',
            text = 'Hello, world!',
            is_enabled = false,
        }) then
        print('3')
    end
    checked = ugui.toggle_button({
        uid = 35,
        margin = '80px 200px',
        size = '200px 50px',
        text = 'Hello, world!',
        is_checked = checked,
    })
    text = ugui.textbox({
        uid = 45,
        margin = '20px 20px',
        padding = '8px 4px',
        text = text,
    })
    text = ugui.textbox({
        uid = 47,
        margin = '20px 60px',
        size = '100px auto+8px',
        text = text,
    })
    position = ugui.joystick({
        uid = 55,
        margin = '20px 200px',
        size = '150px 150px',
        position = position,
    })

    index = ugui.listbox({
        uid = 65,
        margin = '20px 300px',
        size = '120px 200px',
        items = items,
        selected_index = index,
    })
    value = ugui.scrollbar({
        uid = 75,
        margin = '230px 10px',
        size = '20px 300px',
        value = value,
        ratio = 0.2,
    })
    value = ugui.scrollbar({
        uid = 85,
        margin = '280px 10px',
        size = '300px 20px',
        value = value,
        ratio = 0.2,
    })
    index = ugui.combobox({
        uid = 95,
        margin = '200px 300px',
        size = '160px 23px',
        items = items,
        selected_index = index,
    })
    ugui.joystick({
        uid = 105,
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
        uid = 115,
        margin = '355px 350px',
        size = '150px 150px',
        position = {
            x = math.sin(os.clock() / 2) * 50,
            y = math.cos(os.clock() / 2) * 50,
        },
    })
    index = ugui.carrousel_button({
        uid = 125,
        margin = '380px 300px',
        size = '160px 23px',
        items = items,
        selected_index = index,
    })

    num = ugui.numberbox({
        uid = 135,
        margin = '350px 40px',
        size = '160px auto',
        value = num,
        places = 4,
        styler_mixin = {font_size = 20},
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
        margin = '350px 75px',
        size = '160px auto',
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
        margin = '350px 150px',
        size = '160px 23px',
        text = 'Hello World!',
        color = BreitbandGraphics.colors.black,
        font_name = 'Wingdings',
        font_size = 24,
    })
    ugui.label({
        uid = 165,
        margin = '350px 180px',
        size = '160px 23px',
        text = 'Hello World!',
        color = BreitbandGraphics.colors.black,
        font_name = 'Consolas',
        font_size = 24,
        hittestable = true,
    })
    index = ugui.combobox({
        uid = 175,
        margin = '350px 230px',
        size = '160px 23px',
        items = items,
        selected_index = index,
        editable = true,
    })
    ugui.listbox({
        uid = 185,
        margin = '560px 230px',
        size = '160px 160px',
        items = {},
        selected_index = 1,
    })
    ugui.listbox({
        uid = 195,
        margin = '560px 360px',
        size = '160px 160px',
        items = {'a'},
        selected_index = nil,
    })
    if ugui.button({
            uid = 210,
            margin = '620px 10px',
            size = '200px 200px',
            text = '',
        }, function()
            ugui.button({
                uid = 220,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'top left',
            })
            ugui.button({
                uid = 230,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'top center',
                align = 'center top',
            })
            ugui.button({
                uid = 240,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'top right',
                align = 'right top',
            })
            ugui.button({
                uid = 250,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'bottom left',
                align = 'left bottom',
            })
            ugui.button({
                uid = 260,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'bottom center',
                align = 'center bottom',
            })
            ugui.button({
                uid = 270,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'bottom right',
                align = 'right bottom',
            })
            ugui.button({
                uid = 280,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'left center',
                align = 'left center',
            })
            ugui.button({
                uid = 290,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'right center',
                align = 'right center',
            })
            ugui.button({
                uid = 300,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'center',
                align = 'center',
            })
            ugui.button({
                uid = 310,
                margin = '0px 0px',
                size = '50px 23px',
                text = 'smooth',
                align = (math.sin(os.clock() * 2) + 1) / 2 .. ' ' .. (math.cos(os.clock() * 2) + 1) / 2,
            })
        end) then
        index = index + 1
    end
    if ugui.button({
            uid = 320,
            margin = '650px 220px',
            size = '200px',
            text = '',
            is_enabled = false,
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
                align = '50% 100%',
            })
        end) then
        index = index + 1
    end
    num2 = ugui.spinner({
        uid = 350,
        margin = '100px 500px',
        size = '160px 23px',
        value = num2,
    })
    end_frame()
end)
