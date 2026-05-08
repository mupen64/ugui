local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

ugui.DEBUG = true

emu.atdrawd2d(function()
    begin_frame()

    ugui.button({
        uid = 10,
        text = '',
        size = '30% 30%',
        x_align = 0.5,
        y_align = 0.5,
    }, function()
        ugui.button({
            uid = 20,
            text = 'top left',
        })
        ugui.button({
            uid = 30,
            text = 'top center',
            x_align = 0.5,
        })
        ugui.button({
            uid = 40,
            text = 'top right',
            x_align = 1,
        })
        ugui.button({
            uid = 50,
            text = 'center left',
            y_align = 0.5,
        })
        ugui.button({
            uid = 60,
            text = 'center center',
            x_align = 0.5,
            y_align = 0.5,
        })
        ugui.button({
            uid = 70,
            text = 'center right',
            x_align = 1,
            y_align = 0.5,
        })
        ugui.button({
            uid = 80,
            text = 'bottom left',
            x_align = 0,
            y_align = 1,
        })
        ugui.button({
            uid = 90,
            text = 'bottom center',
            x_align = 0.5,
            y_align = 1,
        })
        ugui.button({
            uid = 100,
            text = 'bottom right',
            x_align = 1,
            y_align = 1,
        })
    end)

    end_frame()
end)
