local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()

    local wobblex = (math.sin(os.clock() * 5) + 1) * 200
    local wobbley = (math.sin(os.clock() * -2.5) + 1) * 200
    ugui.push_panel('stackpanel', {
        x = 0,
        y = 0,
    })
    ugui.button({
        uid = 1,
        rectangle = {x = 0, y = 0, width = wobblex, height = wobbley},
        text = '1',
    })
    ugui.button({
        uid = 2,
        rectangle = {x = 0, y = 0, width = 100, height = 100},
        text = '2',
    })
    ugui.push_panel('stackpanel', {
        x = 0,
        y = 0,
        horizontal = true,
    })
    ugui.button({
        uid = 3,
        rectangle = {x = 10, y = 10, width = wobblex, height = wobbley},
        text = '3',
    })
    ugui.button({
        uid = 4,
        rectangle = {x = 10, y = 10, width = 100, height = 100},
        text = '4',
    })
    ugui.pop_panel()
    ugui.pop_panel()

    end_frame()
end)
