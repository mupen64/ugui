local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local value = 5
local selected_index = 1

emu.atdrawd2d(function()
    begin_frame()

    value = ugui.spinner({
        uid = 1,
        rectangle = {
            x = 5,
            y = 10,
            width = 190,
            height = 25,
        },
        value = value,
    })

    local result = ugui.tabcontrol({
        uid = 5,
        rectangle = {
            x = 5,
            y = 40,
            width = 190,
            height = 200,
        },
        items = {
            'ABC',
            'DEFGHI',
            'JKL',
        },
        selected_index = selected_index,
    })

    value = ugui.numberbox({
        uid = 10,
        rectangle = {
            x = 5,
            y = 250,
            width = 190,
            height = 25,
        },
        value = value,
        places = 10,
    })

    selected_index = result.selected_index

    end_frame()
end)
