local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local function rainbow(progress)
    local div = (math.abs(progress % 1) * 3)
    local transition = math.floor((div % 1) * 255)
    local inverse = 255 - transition

    local section = math.floor(div)
    if section == 0 then
        return { 255, transition, 0, 255 }
    elseif section == 1 then
        return { inverse, 255, 0, 255 }
    else
        return { 0, inverse, 255, 255 }
    end
end

local text = 'Hello World!'

emu.atdrawd2d(function()
    begin_frame()

    local selection_color = rainbow(os.clock() / 2)
    ugui.standard_styler.params.textbox.selection = selection_color
    ugui.standard_styler.params.numberbox.selection = selection_color

    text = ugui.textbox({
        uid = 1,
        rectangle = { x = 10, y = 10, width = 100, height = 20 },
        text = text,
    })

    end_frame()
end)
