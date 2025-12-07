local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()

    ugui.with_stackpanel({spacing = 10}, function()
        ugui.button({
            uid = 1,
            rectangle = {x = 0, y = 0, width = 50, height = 50},
            text = '1',
        })
        ugui.button({
            uid = 2,
            rectangle = {x = 0, y = 0, width = 50, height = 50},
            text = '2',
        })

        ugui.with_stackpanel({
            horizontal = true,
            spacing = 10,
        }, function()
            ugui.button({
                uid = 3,
                rectangle = {x = 0, y = 0, width = 50, height = 50},
                text = '3',
            })
            ugui.button({
                uid = 4,
                rectangle = {x = 0, y = 0, width = 50, height = 50},
                text = '4',
            })
            ugui.button({
                uid = 5,
                rectangle = {x = 0, y = 0, width = 50, height = 50},
                text = '5',
            })
        end)
    end)


    end_frame()
end)
