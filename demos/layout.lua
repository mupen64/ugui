local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()

    ugui.push_panel('stackpanel', {
        x = 0,
        y = 0,
        orientation = 'vertical',
        spacing = 5,
    })
    ugui.button({
        uid = 1,
        rectangle = {x = 10, y = 10, width = 100, height = 100},
        text = '1',
    })
    ugui.button({
        uid = 2,
        rectangle = {x = 10, y = 10, width = 100, height = 100},
        text = '2',
    })
    ugui.pop_panel()


    end_frame()
end)
