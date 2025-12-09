local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local items = {'Test A', 'Test B', 'Test C', 'Test D', 'Test E', 'Test F', 'Test G', 'Test H', 'Test I', 'Test J'}
emu.atdrawd2d(function()
    begin_frame()

    ugui.DEBUG = true

    ugui.control({
        uid = 70,
        rectangle = {x = 300, y = 50, width = 300, height = 300},
        text = 'Hello World!',
    }, 'button', nil, false)

    ugui.enter_stack({
        uid = 80,
        rectangle = {x = 0, y = 0, width = 0, height = 0},
        spacing = 10,
        x_align = ugui.alignments.stretch,
        y_align = ugui.alignments.stretch
    })
    ugui.button({
        uid = 90,
        rectangle = {x = 0, y = 0, width = 150, height = 50},
        text = 'Click Me',
        z_index = 10,
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center
    })
    ugui.leave_control()
    ugui.leave_control()

    end_frame()
end)
