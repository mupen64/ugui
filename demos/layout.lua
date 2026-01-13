local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local items = {}
local selected_index = 1
local is_checked = true
local text = 'Hello World'
local value = 0.5
local value2 = 50

for i = 1, 50, 1 do
    items[#items + 1] = 'Test ' .. i .. ' qwertyuiopasdfghjklzxcvbnm'
end

local demos = {}
local demo_index = 1

demos[#demos + 1] = {
    name = 'max size blown out in stack',
    func = function()
        ugui.enter_stack({
            uid = 10,
            rectangle = {x = 0, y = 0, width = 0, height = 0},
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        }, function()
            ugui.button({
                uid = 15,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                text = 'Hello World',
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
                max_size = {y = 20},
            })
            ugui.button({
                uid = 20,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                text = 'Hello World',
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
                min_size = {x = 100, y = 20},
            })
            ugui.button({
                uid = 25,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                text = 'Hello World',
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
                max_size = {y = 20},
            })
        end)
    end,
}

demos[#demos + 1] = {
    name = 'blowing out stack vertical',
    func = function()
        ugui.enter_stack({
            uid = 40,
            rectangle = {x = 0, y = 0, width = 0, height = 0},
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
            max_size = {y = 50},
        }, function()
            ugui.button({
                uid = 45,
                rectangle = {x = 0, y = 0, width = 200, height = 200},
                text = 'Hello World',
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
        end)
    end,
}

demos[#demos + 1] = {
    name = 'blowing out stack horizontal',
    func = function()
        ugui.enter_stack({
            uid = 50,
            rectangle = {x = 0, y = 0, width = 0, height = 0},
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
            max_size = {y = 50},
            horizontal = true,
        }, function()
            ugui.button({
                uid = 55,
                rectangle = {x = 0, y = 0, width = 200, height = 200},
                text = 'Hello World',
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
        end)
    end,
}

demos[#demos + 1] = {
    name = 'all controls',
    func = function()
        ugui.enter_stack({
            uid = 60,
            rectangle = {x = 0, y = 0, width = 0, height = 0},
            spacing = 10,
            x_align = ugui.alignments.center,
            y_align = ugui.alignments.center,
        }, function()
            ugui.button({
                uid = 65,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                text = 'Hello World',
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            is_checked = ugui.toggle_button({
                uid = 70,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                text = 'Hello World',
                is_checked = is_checked,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            selected_index = ugui.carrousel_button({
                uid = 75,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                items = items,
                selected_index = selected_index,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            text = ugui.textbox({
                uid = 80,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                text = text,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            ugui.joystick({
                uid = 85,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                position = {x = 0, y = 0},
                mag = 80,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            value = ugui.trackbar({
                uid = 90,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                value = value,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            value = ugui.trackbar({
                uid = 95,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                value = value,
                vertical = true,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            selected_index = ugui.listbox({
                uid = 100,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                items = items,
                selected_index = selected_index,
                horizontal_scroll = true,
                max_size = {x = 100, y = 50},
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            value = ugui.scrollbar({
                uid = 105,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                value = value,
                ratio = 0.5,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            value = ugui.scrollbar({
                uid = 110,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                value = value,
                ratio = 0.5,
                vertical = true,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            selected_index = ugui.combobox({
                uid = 115,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                items = items,
                selected_index = selected_index,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            value = ugui.spinner({
                uid = 120,
                rectangle = {x = 0, y = 0, width = 0, height = 0},
                value = value,
                increment = 0.1,
                minimum_value = 0,
                maximum_value = 1,
                x_align = ugui.alignments.center,
                y_align = ugui.alignments.center,
            })
            -- value2 = ugui.numberbox({
            --     uid = 125,
            --     rectangle = {x = 0, y = 0, width = 0, height = 0},
            --     value = value2,
            --     places = 4,
            --     x_align = ugui.alignments.center,
            --     y_align = ugui.alignments.center,
            -- })
        end)
    end,
}

emu.atdrawd2d(function()
    begin_frame()

    ugui.DEBUG = true

    demos[demo_index].func()

    local demo_names = {}
    for _, demo in ipairs(demos) do
        demo_names[#demo_names + 1] = demo.name
    end
    demo_index = ugui.carrousel_button({
        uid = 5,
        rectangle = {x = 0, y = -20, width = 0, height = 0},
        items = demo_names,
        selected_index = demo_index,
        x_align = ugui.alignments.center,
        y_align = ugui.alignments['end'],
    })


    -- ugui.enter_stack({
    --     uid = next_uid(),
    --     rectangle = {x = 0, y = 0, width = 0, height = 0},
    --     spacing = 10,
    --     x_align = ugui.alignments.center,
    --     y_align = ugui.alignments.center,
    -- }, function()
    --     selected_index = ugui.listbox({
    --         uid = next_uid(),
    --         rectangle = {x = 0, y = 0, width = 0, height = 0},
    --         items = items,
    --         selected_index = selected_index,
    --         horizontal_scroll = true,
    --         max_size = {y = 50},
    --         x_align = ugui.alignments.center,
    --         y_align = ugui.alignments.center,
    --     })
    --     ugui.button({
    --         uid = next_uid(),
    --         rectangle = {x = 0, y = 0, width = 0, height = 0},
    --         text = 'Hello World',
    --         x_align = ugui.alignments.center,
    --         y_align = ugui.alignments.center,
    --     })
    -- end)

    end_frame()
end)
