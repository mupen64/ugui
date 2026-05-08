local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

ugui.DEBUG = true

emu.atdrawd2d(function()
    begin_frame()

    ugui.button({
        uid = 10,
        text = '',
        size = '30% 30%',
        align = 'center',
    }, function()
        ugui.button({
            uid = 20,
            text = 'top left',
        })
        ugui.button({
            uid = 30,
            text = 'top center',
            align = 'center top',
        })
        ugui.button({
            uid = 40,
            text = 'top right',
            align = 'right top',
        })
        ugui.button({
            uid = 50,
            text = 'center left',
            align = 'left center',
        })
        ugui.button({
            uid = 60,
            text = 'center center',
            align = 'center',
        })
        ugui.button({
            uid = 70,
            text = 'center right',
            align = 'right center',
        })
        ugui.button({
            uid = 80,
            text = 'bottom left',
            align = 'left bottom',
        })
        ugui.button({
            uid = 90,
            text = 'bottom center',
            align = 'center bottom',
        })
        ugui.button({
            uid = 100,
            text = 'bottom right',
            align = 'right bottom',
        })
    end)

    end_frame()
end)
