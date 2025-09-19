local group = {
    name = 'joystick',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_sets_correct_position',
    params = {
        {
            rect = {
                x = 0,
                y = 0,
                width = 128,
                height = 128,
            },
            mouse_position = {
                x = 0,
                y = 0,
            },
            expected_joystick_position = {
                x = -128,
                y = -128,
            },
        },
        {
            rect = {
                x = 0,
                y = 0,
                width = 128,
                height = 128,
            },
            mouse_position = {
                x = 64,
                y = 64,
            },
            expected_joystick_position = {
                x = 0,
                y = 0,
            },
        },
        {
            rect = {
                x = 50,
                y = 80,
                width = 100,
                height = 45,
            },
            mouse_position = {
                x = 65,
                y = 102,
            },
            expected_joystick_position = {
                x = -89.6,
                y = -2.844,
            },
        },
        {
            rect = {
                x = 10,
                y = 20,
                width = 5,
                height = 500,
            },
            mouse_position = {
                x = 15,
                y = 405,
            },
            expected_joystick_position = {
                x = 128,
                y = 69.12,
            },
        },
        {
            rect = {
                x = 0,
                y = 0,
                width = 128,
                height = 128,
            },
            mouse_position = {
                x = 65,
                y = 65,
            },
            expected_joystick_position = {
                x = 0,
                y = 0,
            },
            x_snap = 8,
            y_snap = 8,
        },
    },
    func = function(ctx)
        local position = {x = 0, y = 0}

        ugui.begin_frame({
            mouse_position = ctx.data.mouse_position,
            wheel = 0,
            is_primary_down = true,
            held_keys = {},
        })
        ugui.internal.capturing_control = 5
        position = ugui.joystick({
            uid = 5,
            rectangle = ctx.data.rect,
            position = position,
            x_snap = ctx.data.x_snap,
            y_snap = ctx.data.y_snap,
        })
        ugui.end_frame()

        ctx.assert(math.floor(position.x) == math.floor(ctx.data.expected_joystick_position.x), string.format('Expected x position %f, got %f', ctx.data.expected_joystick_position.x, position.x))
        ctx.assert(math.floor(position.y) == math.floor(ctx.data.expected_joystick_position.y), string.format('Expected y position %f, got %f', ctx.data.expected_joystick_position.y, position.y))
    end,
}

group.tests[#group.tests + 1] = {
    name = 'nil_params_no_error',
    pass_if_no_error = true,
    func = function(ctx)
        local rect = {
            x = 50,
            y = 80,
            width = 100,
            height = 45,
        }
        ugui.begin_frame({
            mouse_position = {x = 0, y = 0},
            wheel = 0,
            is_primary_down = true,
            held_keys = {},
        })
        ugui.internal.capturing_control = 5
        ugui.joystick({
            uid = 5,
            rectangle = rect,
            position = nil,
        })
        ugui.end_frame()
    end,
}

return group
