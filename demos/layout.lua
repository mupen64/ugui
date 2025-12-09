local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local items = {'Test A', 'Test B', 'Test C', 'Test D', 'Test E', 'Test F', 'Test G', 'Test H', 'Test I', 'Test J'}
emu.atdrawd2d(function()
    begin_frame()

    ugui.DEBUG = true

    ugui.enter_control('stack', {uid = 0, rectangle = {x = 0, y = 0, width = 0, height = 0}, spacing = 10})

    ugui.combobox({
        uid = 10,
        rectangle = {x = 0, y = 0, width = 100, height = 30},
        items = items,
        selected_index = 1,
    })
    ugui.combobox({
        uid = 20,
        rectangle = {x = 0, y = 200, width = 100, height = 30},
        items = items,
        selected_index = 2,
    })

    ugui.enter_control('stack', {uid = 30, rectangle = {x = 0, y = 0, width = 0, height = 0}, horizontal = true, spacing = -30})

    ugui.combobox({
        uid = 40,
        rectangle = {x = 0, y = 0, width = 100, height = 30},
        items = items,
        selected_index = 3,
    })
    ugui.combobox({
        uid = 50,
        rectangle = {x = 0, y = 0, width = 100, height = 30},
        z_index = 1,
        items = items,
        selected_index = 4,
    })
    ugui.combobox({
        uid = 60,
        rectangle = {x = 0, y = 0, width = 100, height = 30},
        items = items,
        selected_index = 5,
    })

    ugui.leave_control()
    ugui.leave_control()

    end_frame()
end)
