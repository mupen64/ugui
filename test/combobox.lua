local group = {
    name = 'combobox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_shows_topmost_listbox',
    func = function(ctx)
        local called = false
        ugui.listbox = function(lb)
            called = true
            ctx.assert(lb.topmost, 'ugui.listbox called, but not with topmost flag')
        end

        local rect = {
            x = 10,
            y = 10,
            width = 100,
            height = 25,
        }

        for i = 1, 3, 1 do
            ugui.begin_frame({
                mouse_position = {x = 15, y = 15},
                wheel = 0,
                is_primary_down = i == 2,
                key_events = {},
            })
            ugui.combobox({
                uid = 5,
                rectangle = rect,
                items = {'A', 'B', 'C'},
                selected_index = 1,
            })
            ugui.end_frame()
        end

        ctx.assert(called, 'ugui.listbox not called')
    end,
}

group.tests[#group.tests + 1] = {
    name = 'click_outside_hides_listbox',
    func = function(ctx)
        local rect = {
            x = 10,
            y = 10,
            width = 100,
            height = 25,
        }

        ugui.begin_frame({
            mouse_position = {x = 0, y = 0},
            wheel = 0,
            is_primary_down = false,
            key_events = {},
        })
        ugui.combobox({
            uid = 5,
            rectangle = rect,
            items = {'A', 'B', 'C'},
            selected_index = 1,
        })
        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = {x = 15, y = 15},
            wheel = 0,
            is_primary_down = true,
            key_events = {},
        })
        ugui.combobox({
            uid = 5,
            rectangle = rect,
            items = {'A', 'B', 'C'},
            selected_index = 1,
        })
        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = {x = 15, y = 15},
            wheel = 0,
            is_primary_down = false,
            key_events = {},
        })
        ugui.combobox({
            uid = 5,
            rectangle = rect,
            items = {'A', 'B', 'C'},
            selected_index = 1,
        })
        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = {x = 200, y = 200},
            wheel = 0,
            is_primary_down = true,
            key_events = {},
        })
        local called = false
        ugui.listbox = function(lb)
            called = true
        end
        ugui.combobox({
            uid = 5,
            rectangle = rect,
            items = {'A', 'B', 'C'},
            selected_index = 1,
        })
        ugui.end_frame()
        ctx.assert(not called, 'ugui.listbox called')
    end,
}

return group
