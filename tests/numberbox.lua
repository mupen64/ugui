local group = {
    name = 'numberbox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'highlight_draws_at_expected_position',
    params = {
        {
            font_name = 'Consolas',
            places = 10,
            selected_index = 1,
            expected_x_position = 46,
        },
        {
            font_name = 'Consolas',
            places = 10,
            selected_index = 2,
            expected_x_position = 55,
        },
        {
            font_name = 'Consolas',
            places = 10,
            selected_index = 3,
            expected_x_position = 65,
        },
        {
            font_name = 'Consolas',
            places = 10,
            selected_index = 4,
            expected_x_position = 75,
        },
        {
            font_name = 'Consolas',
            places = 10,
            selected_index = 8,
            expected_x_position = 115,
        },
        {
            font_name = 'Consolas',
            places = 10,
            selected_index = 9,
            expected_x_position = 125,
        },
        {
            font_name = 'Consolas',
            places = 10,
            selected_index = 10,
            expected_x_position = 135,
        },
    },
    func = function(ctx)
        ugui.begin_frame({
            mouse_position = {
                x = 0,
                y = 0,
            },
            wheel = 0,
            held_keys = {},
        })

        ugui.standard_styler.params.font_name = ctx.data.font_name
        ugui.internal.control_data[1] = {
            caret_index = ctx.data.selected_index,
        }
        ugui.internal.capturing_control = 1

        local real_position = nil

        BreitbandGraphics.fill_rectangle = function(rectangle, color)
            if BreitbandGraphics.color_to_hex(color) == '#0078D7' then
                real_position = rectangle.x
            end
        end

        ugui.numberbox({
            uid = 1,
            rectangle = {
                x = 0,
                y = 0,
                width = 190,
                height = 25,
            },
            value = 0,
            places = ctx.data.places,
        })

        ugui.end_frame()

        ctx.assert_eq(ctx.data.expected_x_position, real_position)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'click_selects_correct_digit',
    params = {
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 10,
            expected_caret_index = 1,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 60,
            expected_caret_index = 2,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 70,
            expected_caret_index = 3,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 80,
            expected_caret_index = 4,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 90,
            expected_caret_index = 5,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 100,
            expected_caret_index = 6,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 110,
            expected_caret_index = 7,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 120,
            expected_caret_index = 8,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 130,
            expected_caret_index = 9,
        },
        {
            font_name = 'Consolas',
            places = 10,
            mouse_x = 140,
            expected_caret_index = 10,
        },
    },
    func = function(ctx)
        ugui.standard_styler.params.font_name = ctx.data.font_name

        ugui.begin_frame({
            mouse_position = {
                x = ctx.data.mouse_x,
                y = 1,
            },
            wheel = 0,
            held_keys = {},
        })

        ugui.numberbox({
            uid = 1,
            rectangle = {
                x = 0,
                y = 0,
                width = 190,
                height = 25,
            },
            value = 0,
            places = ctx.data.places,
        })

        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = {
                x = ctx.data.mouse_x,
                y = 1,
            },
            is_primary_down = true,
            wheel = 0,
            held_keys = {},
        })

        ugui.numberbox({
            uid = 1,
            rectangle = {
                x = 0,
                y = 0,
                width = 190,
                height = 25,
            },
            value = 0,
            places = ctx.data.places,
        })

        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = {
                x = ctx.data.mouse_x,
                y = 1,
            },
            is_primary_down = true,
            wheel = 0,
            held_keys = {},
        })

        ugui.numberbox({
            uid = 1,
            rectangle = {
                x = 0,
                y = 0,
                width = 190,
                height = 25,
            },
            value = 0,
            places = ctx.data.places,
        })

        ugui.end_frame()

        ctx.assert_eq(ctx.data.expected_caret_index, ugui.internal.control_data[1].caret_index)
    end,
}


return group
