local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local items = {'Test A', 'Test B', 'Test C', 'Test D', 'Test E', 'Test F', 'Test G', 'Test H', 'Test I', 'Test J'}
local uid = 0
local function next_uid()
    uid = uid + 10
    return uid
end
emu.atdrawd2d(function()
    begin_frame()

    uid = 0
    ugui.DEBUG = true

    ugui.control({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 300, height = 300},
        text = 'Hello World!',
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    }, 'button', nil, false)

    ugui.enter_stack({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 0, height = 0},
        spacing = 50,
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    })
    ugui.button({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 150, height = 50},
        text = 'Click Me',
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    })

    ugui.enter_stack({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 0, height = 0},
        horizontal = true,
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    })
    ugui.button({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 150, height = 50},
        text = 'Click Me',
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    })
    ugui.button({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 150, height = 50},
        text = 'Click Me',
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    })
    ugui.button({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 150, height = 50},
        text = 'Click Me',
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    })
    ugui.leave_control()


    ugui.button({
        uid = next_uid(),
        rectangle = {x = 0, y = 0, width = 150, height = 50},
        text = 'Click Me',
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    })
    ugui.leave_control()

    ugui.leave_control()

    end_frame()
end)
