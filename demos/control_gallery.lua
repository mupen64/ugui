local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()

    ugui.button({
        uid = 100,
        rectangle = {
            x = 0,
            y = 10,
            width = 90,
            height = 30,
        },
        text = 'Test',
    })

    if (ugui.button({
            uid = 200,
            is_enabled = false,
            rectangle = {
                x = 100,
                y = 10,
                width = 90,
                height = 30,
            },
            text = 'Test',
        })) then
        print('a')
    end

    ugui.textbox({
        uid = 300,
        rectangle = {
            x = 0,
            y = 50,
            width = 90,
            height = 30,
        },
        text = 'Test',
    })

    ugui.textbox({
        uid = 400,
        is_enabled = false,
        rectangle = {
            x = 100,
            y = 50,
            width = 90,
            height = 30,
        },
        text = 'Test',
    })

    ugui.combobox({
        uid = 500,
        rectangle = {
            x = 0,
            y = 90,
            width = 90,
            height = 30,
        },
        items = {
            'Test',
        },
        selected_index = 1,
    })

    ugui.combobox({
        uid = 600,
        is_enabled = false,
        rectangle = {
            x = 100,
            y = 90,
            width = 90,
            height = 30,
        },
        items = {
            'Test',
        },
        selected_index = 1,
    })

    value = ugui.trackbar({
        uid = 700,
        rectangle = {
            x = 0,
            y = 130,
            width = 90,
            height = 30,
        },
        value = value,
    })

    ugui.trackbar({
        uid = 800,
        is_enabled = false,
        rectangle = {
            x = 100,
            y = 130,
            width = 90,
            height = 30,
        },
        value = value,
    })


    ugui.listbox({
        uid = 900,
        rectangle = {
            x = 0,
            y = 170,
            width = 90,
            height = 30,
        },
        selected_index = 1,
        items = {
            'Test',
            'Item',
        },
    })

    ugui.listbox({
        uid = 1000,
        is_enabled = false,
        rectangle = {
            x = 100,
            y = 170,
            width = 90,
            height = 30,
        },
        selected_index = 1,
        items = {
            'Test',
            'Item',
        },
    })

    ugui.joystick({
        uid = 1100,
        rectangle = {
            x = 0,
            y = 210,
            width = 90,
            height = 90,
        },
        position = {
            x = 0,
            y = 0.5,
        },
        mag = 0,
    })

    ugui.joystick({
        uid = 1200,
        is_enabled = false,
        rectangle = {
            x = 100,
            y = 210,
            width = 90,
            height = 90,
        },
        position = {
            x = 1,
            y = 0.5,
        },
        mag = 0,
    })

    end_frame()
end)
