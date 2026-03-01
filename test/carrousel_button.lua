local group = {
    name = 'carrousel_button',
    tests = {},
}

local items = {
    'Foo',
    'Bar',
    'Baz',
}

group.tests[#group.tests + 1] = {
    name = 'left_click_decrements_index',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 2
        local meta

        for i = 1, 6, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i == 2,
                key_events = {},
            })

            index, meta = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            if i == 3 then
                ctx.assert_eq(ugui.signal_change_states.started, meta.signal_change)
            elseif i == 4 then
                ctx.assert_eq(ugui.signal_change_states.ongoing, meta.signal_change)
            elseif i == 5 then
                ctx.assert_eq(ugui.signal_change_states.ended, meta.signal_change)
            end

            ugui.end_frame()
        end

        ctx.assert_eq(1, index)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'right_click_increments_index',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 2

        for i = 1, 6, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 90,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i == 2,
                key_events = {},
            })

            index, meta = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            if i == 3 then
                ctx.assert_eq(ugui.signal_change_states.started, meta.signal_change)
            elseif i == 4 then
                ctx.assert_eq(ugui.signal_change_states.ongoing, meta.signal_change)
            elseif i == 5 then
                ctx.assert_eq(ugui.signal_change_states.ended, meta.signal_change)
            end

            ugui.end_frame()
        end

        ctx.assert_eq(3, index)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'min_to_max_wraparound_works',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 1

        for i = 1, 3, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                key_events = {},
            })

            index = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            ugui.end_frame()
        end

        ctx.assert_eq(3, index)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'max_to_min_wraparound_works',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 3

        for i = 1, 3, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 90,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                key_events = {},
            })

            index = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            ugui.end_frame()
        end

        ctx.assert_eq(1, index)
    end,
}

return group
