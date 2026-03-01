local group = {
    name = 'toggle_button',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_toggles_check_state',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local checked = false

        for i = 1, 5, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                key_events = {},
            })

            checked = ugui.toggle_button({
                uid = 5,
                rectangle = button_rect,
                text = 'Hello World!',
                is_checked = checked,
            })

            ugui.end_frame()
        end

        ctx.assert_eq(false, checked)
    end,
}

return group
