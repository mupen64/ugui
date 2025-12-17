local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local items = { 'Test A', 'Test B', 'Test C', 'Test D', 'Test E', 'Test F', 'Test G', 'Test H', 'Test I', 'Test J', 'Test K', 'Test L', 'Test M', 'Test N', 'Test O', 'Test P', 'Test Q', 'Test R', 'Test S', 'Test T', 'Test U', 'Test V', 'Test W', 'Test X', 'Test Y', 'Test Z' }
local selected_index = 1
local is_checked = true
local text = "Hello World"
local value = 0.5
local value2 = 50

local uid = 0
local function next_uid()
    uid = uid + 10
    return uid
end

emu.atdrawd2d(function()
    begin_frame()

    uid = 0
    ugui.DEBUG = true

    ugui.enter_stack({
        uid = next_uid(),
        rectangle = { x = 0, y = 0, width = 0, height = 0 },
        spacing = 10,
        x_align = ugui.alignments.center,
        y_align = ugui.alignments.center,
    }, function()
        ugui.button({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            text = 'Hello World',
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        is_checked = ugui.toggle_button({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            text = 'Hello World',
            is_checked = is_checked,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        selected_index = ugui.carrousel_button({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            items = items,
            selected_index = selected_index,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        text = ugui.textbox({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            text = text,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        ugui.joystick({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            position = { x = 0, y = 0 },
            mag = 80,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        value = ugui.trackbar({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            value = value,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        value = ugui.trackbar({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            value = value,
            vertical = true,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        selected_index = ugui.listbox({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            items = items,
            selected_index = selected_index,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        value = ugui.scrollbar({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            value = value,
            ratio = 0.5,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        value = ugui.scrollbar({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            value = value,
            ratio = 0.5,
            vertical = true,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        selected_index = ugui.combobox({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            items = items,
            selected_index = selected_index,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        value = ugui.spinner({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            value = value,
            increment = 0.1,
            minimum_value = 0,
            maximum_value = 1,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
        value2 = ugui.numberbox({
            uid = next_uid(),
            rectangle = { x = 0, y = 0, width = 0, height = 0 },
            value = value2,
            places = 4,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        })
    end)

    end_frame()
end)
