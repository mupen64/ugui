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

        for i = 1, 2, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i == 2,
                held_keys = {},
            })

            local pressed = ugui.button({
                uid = 5,
                rectangle = button_rect,
                text = 'Hello World!',
            })

            if i == 2 then
                ctx.assert(pressed, 'Button not pressed')
            end

            ugui.end_frame()
        end
    end,
}

return group
