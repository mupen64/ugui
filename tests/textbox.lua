local group = {
    name = 'textbox',
    tests = {},
}

-- NOTE: This is pretty flaky since it depends on D2D text measuring behaviour but whatever
group.tests[#group.tests + 1] = {
    name = 'click_picks_correct_selection_start_index',
    params = {
        {
            mouse_x = 12,
            expected_start_index = 3,
        },
        {
            mouse_x = 24,
            expected_start_index = 5,
        },
        {
            mouse_x = 25,
            expected_start_index = 5,
        },
        {
            mouse_x = 99,
            expected_start_index = 5,
        },
    },
    func = function(ctx)
        local rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        for i = 1, 3, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = ctx.data.mouse_x,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i == 2,
                held_keys = {},
            })

            ugui.textbox({
                uid = 5,
                rectangle = rect,
                text = 'Test',
            })

            if i == 3 then
                ctx.assert(ugui.internal.control_data[5].selection_start == ctx.data.expected_start_index, string.format('Expected selection start %d, got %d', ctx.data.expected_start_index, ugui.internal.control_data[5].selection_start))
            end

            ctx.log((ugui.internal.control_data[5].selection_start or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)

            ugui.end_frame()
        end
    end,
}

-- NOTE: This is pretty flaky since it depends on D2D text measuring behaviour but whatever
group.tests[#group.tests + 1] = {
    name = 'drag_picks_correct_selection_indicies',
    params = {
        {
            begin_mouse_x = 12,
            end_mouse_x = 99,
            expected_start_index = 3,
            expected_end_index = 5,
        },
        {
            begin_mouse_x = 99,
            end_mouse_x = 12,
            expected_start_index = 3,
            expected_end_index = 5,
        },
    },
    func = function(ctx)
        local rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        for i = 1, 6, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = i > 3 and ctx.data.end_mouse_x or ctx.data.begin_mouse_x,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i > 1,
                held_keys = {},
            })

            ugui.textbox({
                uid = 5,
                rectangle = rect,
                text = 'Test',
            })

            ugui.end_frame()

            if i == 6 then
                ctx.assert_eq(ctx.data.expected_start_index, ugui.internal.control_data[5].selection_start)
                ctx.assert_eq(ctx.data.expected_end_index, ugui.internal.control_data[5].selection_end)
            end

            ctx.log((ugui.internal.control_data[5].selection_start or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)
            ctx.log((ugui.internal.control_data[5].selection_end or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)
        end
    end,
}

group.tests[#group.tests + 1] = {
    name = 'arrow_keys_modify_caret_index',
    params = {
        {
            key = 'left',
            initial_start_index = 2,
            initial_end_index = 3,
            expected_caret_index = 2,
        },
        {
            key = 'left',
            initial_start_index = 2,
            initial_end_index = 2,
            expected_caret_index = 1,
        },
        {
            key = 'right',
            initial_start_index = 2,
            initial_end_index = 3,
            expected_caret_index = 3,
        },
        {
            key = 'right',
            initial_start_index = 2,
            initial_end_index = 2,
            expected_caret_index = 3,
        },
    },
    func = function(ctx)
        local rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        ugui.begin_frame({
            mouse_position = {x = 10, y = 10},
            wheel = 0,
            is_primary_down = false,
            held_keys = {},
        })
        ugui.textbox({
            uid = 5,
            rectangle = rect,
            text = 'Test',
        })
        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = {x = 10, y = 10},
            wheel = 0,
            is_primary_down = true,
            held_keys = {},
        })
        ugui.textbox({
            uid = 5,
            rectangle = rect,
            text = 'Test',
        })
        ugui.end_frame()

        ugui.internal.control_data[5].caret_index = ctx.data.initial_start_index
        ugui.internal.control_data[5].selection_start = ctx.data.initial_start_index
        ugui.internal.control_data[5].selection_end = ctx.data.initial_end_index

        ugui.begin_frame({
            mouse_position = {x = 10, y = 10},
            wheel = 0,
            is_primary_down = false,
            held_keys = {[ctx.data.key] = true},
        })
        ugui.textbox({
            uid = 5,
            rectangle = rect,
            text = 'Test',
        })
        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = {x = 10, y = 10},
            wheel = 0,
            is_primary_down = false,
            held_keys = {[ctx.data.key] = true},
        })
        ugui.textbox({
            uid = 5,
            rectangle = rect,
            text = 'Test',
        })
        ugui.end_frame()

        ctx.assert(ugui.internal.control_data[5].caret_index == ctx.data.expected_caret_index, string.format('Expected caret index %d, got %d', ctx.data.expected_caret_index, ugui.internal.control_data[5].caret_index))
    end,
}

group.tests[#group.tests + 1] = {
    name = 'keys_modify_text_correctly',
    params = {
        {
            key = 'A',
            text = 'Hello World!',
            expected_text = 'HAello World!',
            caret_index = 2,
            start_index = 2,
            end_index = 2,
        },
        {
            key = 'backspace',
            text = 'Hello World!',
            expected_text = 'ello World!',
            caret_index = 2,
            start_index = 2,
            end_index = 2,
        },
        {
            key = 'backspace',
            text = 'Hello World!',
            expected_text = 'llo World!',
            caret_index = 3,
            start_index = 1,
            end_index = 3,
        },
        {
            key = 'A',
            text = 'Hello World!',
            expected_text = 'Allo World!',
            caret_index = 3,
            start_index = 1,
            end_index = 3,
        },
        {
            key = 'A',
            text = 'Hello World!',
            expected_text = 'A',
            caret_index = 13,
            start_index = 1,
            end_index = 13,
        },
        {
            key = 'backspace',
            text = 'Hello World!',
            expected_text = '',
            caret_index = 13,
            start_index = 1,
            end_index = 13,
        },
        {
            key = 'O',
            text = 'Hello World!',
            expected_text = 'Hello World!O',
            caret_index = 13,
            start_index = 13,
            end_index = 13,
        },
    },
    func = function(ctx)
        local rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local text = ctx.data.text

        ugui.begin_frame({
            mouse_position = {x = 10, y = 10},
            wheel = 0,
            is_primary_down = false,
            held_keys = {},
        })
        ugui.internal.keyboard_captured_control = 5
        ugui.internal.mouse_captured_control = 5
        text = ugui.textbox({
            uid = 5,
            rectangle = rect,
            text = text,
        })
        ugui.end_frame()

        ugui.internal.control_data[5].caret_index = ctx.data.caret_index
        ugui.internal.control_data[5].selection_start = ctx.data.start_index
        ugui.internal.control_data[5].selection_end = ctx.data.end_index

        ugui.begin_frame({
            mouse_position = {x = 10, y = 10},
            wheel = 0,
            is_primary_down = false,
            held_keys = {[ctx.data.key] = true},
        })
        text = ugui.textbox({
            uid = 5,
            rectangle = rect,
            text = text,
        })
        ugui.end_frame()

        ctx.assert(text == ctx.data.expected_text, string.format('Expected text \"%s\", got \"%s\"', ctx.data.expected_text, text))
    end,
}

return group
