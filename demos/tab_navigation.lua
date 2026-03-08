local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()

    ugui.button({
        uid = 1,
        rectangle = {
            x = 40,
            y = 40,
            width = 80,
            height = 23,
        },
        text = '1',
    })

    ugui.button({
        uid = 2,
        rectangle = {
            x = 40,
            y = 70,
            width = 80,
            height = 23,
        },
        text = '2',
    })


    ugui.button({
        uid = 3,
        rectangle = {
            x = 40,
            y = 100,
            width = 80,
            height = 23,
        },
        text = 'trap 1',
    })

    ugui.button({
        uid = 4,
        rectangle = {
            x = 130,
            y = 100,
            width = 80,
            height = 23,
        },
        text = 'trap 2',
        next_uid = 3,
    })

    ugui.button({
        uid = 5,
        rectangle = {
            x = 40,
            y = 130,
            width = 80,
            height = 23,
        },
        text = '3',
    })

    ugui.button({
        uid = 6,
        is_enabled = false,
        rectangle = {
            x = 40,
            y = 160,
            width = 80,
            height = 23,
        },
        text = '4',
    })

    end_frame()
end)
