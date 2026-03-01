local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local rectangle = {
    x = 5,
    y = 200,
    width = 100,
    height = 100,
}

emu.atdrawd2d(function()
    begin_frame()

    BreitbandGraphics.draw_rectangle(rectangle, BreitbandGraphics.colors.red, 1)
    BreitbandGraphics.draw_text2({
        text = '(start, start)',
        rectangle = rectangle,
        align_x = BreitbandGraphics.alignment.start,
        align_y = BreitbandGraphics.alignment.start,
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
        fit = true,
    })
    BreitbandGraphics.draw_text2({
        text = '(center, center)',
        rectangle = rectangle,
        align_x = BreitbandGraphics.alignment.center,
        align_y = BreitbandGraphics.alignment.center,
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
        fit = true,
    })
    BreitbandGraphics.draw_text2({
        text = '(end, end)',
        rectangle = rectangle,
        align_x = BreitbandGraphics.alignment['end'],
        align_y = BreitbandGraphics.alignment['end'],
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
        fit = true,
    })

    local mup_input = input.get()
    if mup_input.leftclick then
        rectangle.width = math.max(1, mup_input.xmouse)
        rectangle.height = math.max(1, mup_input.ymouse)
    end

    if mup_input.rightclick then
        rectangle.x = math.max(1, mup_input.xmouse)
        rectangle.y = math.max(1, mup_input.ymouse)
    end

    for _, e in ipairs(ugui.internal.environment.key_events) do
        if e.keycode == ugui.keycodes.VK_F1 and e.pressed then
            print(rectangle)
        end
    end

    end_frame()
end)
