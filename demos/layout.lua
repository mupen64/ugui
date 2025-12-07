local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()

    ugui.push_panel('stackpanel', {
        x = 0,
        y = 0,
        spacing = 10,
    })
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
    ugui.push_panel('stackpanel', {
        x = 0,
        y = 0,
        horizontal = true,
        spacing = 10
    })
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
    ugui.pop_panel()
    ugui.pop_panel()

    end_frame()
end)
