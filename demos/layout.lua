local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local items = {'Test A', 'Test B', 'Test C'}
emu.atdrawd2d(function()
    begin_frame()

    ugui.DEBUG = true

    ugui.with_stackpanel({spacing = 10}, function()
        ugui.combobox({
            uid = 10,
            rectangle = {x = 0, y = 0, width = 100, height = 30},
            items = items,
            selected_index = 1,
        })
        ugui.combobox({
            uid = 20,
            rectangle = {x = 0, y = 0, width = 100, height = 30},
            items = items,
            selected_index = 1,
        })

        ugui.with_stackpanel({
            horizontal = true,
            spacing = -30,
        }, function()
            ugui.combobox({
                uid = 30,
                rectangle = {x = 0, y = 0, width = 100, height = 30},
                items = items,
                selected_index = 1,
            })
            ugui.combobox({
                uid = 40,
                rectangle = {x = 0, y = 0, width = 100, height = 30},
                z_index = 1,
                items = items,
                selected_index = 1,
            })
            ugui.combobox({
                uid = 50,
                rectangle = {x = 0, y = 0, width = 100, height = 30},
                items = items,
                selected_index = 1,
            })
        end)
    end)


    end_frame()
end)
