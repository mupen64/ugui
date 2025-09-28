local group = {
    name = 'listbox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'draw_text_called_correctly',
    func = function(ctx)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'click_sets_correct_selected_index',
    params = {
        {
            items = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'},
            rect = {x = 10, y = 10, width = 100, height = 200},
            mouse_position = {x = 11, y = 11},
            expected_index = 1,
        },
        {
            items = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'},
            rect = {x = 10, y = 10, width = 100, height = 200},
            mouse_position = {x = 11, y = 60},
            expected_index = 4,
        },
        {
            items = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'},
            rect = {x = 10, y = 10, width = 100, height = 200},
            mouse_position = {x = 11, y = 99},
            expected_index = 6,
        },
    },
    func = function(ctx)
        local selected_index = 999

        for i = 1, 3, 1 do
            ugui.begin_frame({
                mouse_position = ctx.data.mouse_position,
                wheel = 0,
                is_primary_down = i > 1,
                held_keys = {},
            })
            selected_index = ugui.listbox({
                uid = 5,
                rectangle = ctx.data.rect,
                items = ctx.data.items,
                selected_index = selected_index,
            })
            ugui.end_frame()
        end

        ctx.log(selected_index)
        ctx.assert_eq(ctx.data.expected_index, selected_index)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'overflow_shows_scrollbars',
    func = function(ctx)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'pressing_navigation_keys_while_hovering_without_selection_does_not_crash',
    params = {
        {
            items = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'},
            rect = {x = 10, y = 10, width = 100, height = 200},
            mouse_position = {x = 20, y = 20},
            key = 'up',
        },
        {
            items = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'},
            rect = {x = 10, y = 10, width = 100, height = 200},
            mouse_position = {x = 20, y = 20},
            key = 'down',
        },
    },
    func = function(ctx)
        ugui.begin_frame({
            mouse_position = ctx.data.mouse_position,
            wheel = 0,
            held_keys = {},
        })
        ugui.listbox({
            uid = 5,
            rectangle = ctx.data.rect,
            items = ctx.data.items,
        })
        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = ctx.data.mouse_position,
            wheel = 0,
            held_keys = {[ctx.data.key] = true},
        })
        local success, _ = pcall(function()
            ugui.listbox({
                uid = 5,
                rectangle = ctx.data.rect,
                items = ctx.data.items,
            })
        end)
        ctx.assert_eq(true, success)
        ugui.end_frame()
    end,
}

return group
