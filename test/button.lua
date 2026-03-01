local group = {
    name = 'button',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_returns_true',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local pressed

        for i = 1, 3, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i == 2,
                key_events = {},
            })

            pressed = ugui.button({
                uid = 5,
                rectangle = button_rect,
                text = 'Hello World!',
            })

            ugui.end_frame()
        end

        ctx.assert_eq(true, pressed)
    end,
}

return group
