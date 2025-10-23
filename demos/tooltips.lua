local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()

    ugui.combobox({
        uid = 1,
        rectangle = {x = 10, y = 10, width = 90, height = 20},
        items = {
            'Hello',
            'Hello',
            'Hello',
            'Hello',
            'Hello',
        },
        selected_index = 1,
        tooltip = 'i have a tooltip too wow',
    })

    ugui.button({
        uid = 3,
        rectangle = {x = 0, y = 35, width = 800, height = 20},
        text = 'Hover Here',
        tooltip = 'Hello World!',
    })

    ugui.button({
        uid = 4,
        rectangle = {x = 10, y = 60, width = 90, height = 20},
        text = 'Hover Here',
        tooltip = 'Voluptas culpa officia consequatur eveniet. Sint fugiat culpa rerum debitis. Et ea cupiditate nulla eius saepe minima. Aspernatur omnis ut amet incidunt sequi doloremque corrupti. Corrupti vero quae rerum est recusandae perferendis.',
    })

    ugui.button({
        uid = 76,
        rectangle = {x = 10, y = 90, width = 90, height = 20},
        text = 'Im boring',
    })

    ugui.button({
        uid = 80,
        rectangle = {x = 10, y = 120, width = 90, height = 20},
        is_enabled = false,
        text = 'nope',
        tooltip = '!!!',
    })

    ugui.button({
        uid = 5,
        rectangle = {x = 700, y = 540, width = 90, height = 50},
        text = 'Hover Here',
        tooltip = 'Wow.',
    })

    end_frame()
end)
