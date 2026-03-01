local group = {
    name = 'tooltip',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'appears_when_it_should',
    params = {
        {
            rect = {
                x = 1,
                y = 1,
                width = 10,
                height = 10,
            },
            enabled = true,
            mouse_position = {
                x = 0,
                y = 0,
            },
            should_appear = false,
        },
        {
            rect = {
                x = 1,
                y = 1,
                width = 10,
                height = 10,
            },
            enabled = true,
            mouse_position = {
                x = 2,
                y = 2,
            },
            should_appear = true,
        },
        {
            rect = {
                x = 1,
                y = 1,
                width = 10,
                height = 10,
            },
            enabled = false,
            mouse_position = {
                x = 0,
                y = 0,
            },
            should_appear = false,
        },
        {
            rect = {
                x = 1,
                y = 1,
                width = 10,
                height = 10,
            },
            enabled = false,
            mouse_position = {
                x = 1,
                y = 1,
            },
            should_appear = false,
        },
    },
    func = function(ctx)
        local tooltip_drawn = false
        BreitbandGraphics.draw_text2 = function(params)
            if params.text == 'tooltip' then
                tooltip_drawn = true
            end
        end

        ugui.begin_frame({
            mouse_position = ctx.data.mouse_position,
            wheel = 0,
            is_primary_down = false,
            key_events = {},
        })
        ugui.standard_styler.params.tooltip.delay = 0
        ugui.button({
            uid = 5,
            rectangle = ctx.data.rect,
            text = 'Hello World!',
            tooltip = 'tooltip',
            is_enabled = ctx.data.enabled,
        })
        ugui.end_frame()

        ctx.assert_eq(ctx.data.should_appear, tooltip_drawn)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'rectangle_is_as_expected',
    params = {
        {
            window_size = {
                x = 800,
                y = 600,
            },
            rect = {
                x = 0,
                y = 0,
                width = 800,
                height = 600,
            },
            tooltip = 'Tooltip',
            mouse_position = {
                x = 799,
                y = 300,
            },
            expected = {
                x = 761,
                y = 323,
                width = 42,
                height = 20,
            },
        },
        {
            window_size = {
                x = 800,
                y = 600,
            },
            rect = {
                x = 0,
                y = 0,
                width = 800,
                height = 600,
            },
            tooltip = 'Tooltip',
            mouse_position = {
                x = 100,
                y = 300,
            },
            expected = {
                x = 97,
                y = 323,
                width = 42,
                height = 20,
            },
        },
        {
            window_size = {
                x = 800,
                y = 600,
            },
            rect = {
                x = 0,
                y = 0,
                width = 800,
                height = 600,
            },
            tooltip = 'Tooltip',
            mouse_position = {
                x = 799,
                y = 599,
            },
            expected = {
                x = 761,
                y = 579,
                width = 42,
                height = 20,
            },
        },
        {
            window_size = {
                x = 800,
                y = 600,
            },
            rect = {
                x = 0,
                y = 0,
                width = 800,
                height = 600,
            },
            tooltip = 'longtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtextlongtext',
            mouse_position = {
                x = 400,
                y = 300,
            },
            expected = {
                x = 1,
                y = 323,
                width = 798,
                height = 20,
            },
        },
    },
    func = function(ctx)
        local tooltip_rect
        BreitbandGraphics.fill_rectangle = function(rectangle, color)
            if color == ugui.standard_styler.params.menu.back[ugui.visual_states.normal] then
                tooltip_rect = rectangle
            end
        end

        ugui.begin_frame({
            mouse_position = ctx.data.mouse_position,
            wheel = 0,
            is_primary_down = false,
            key_events = {},
            window_size = ctx.data.window_size,
        })
        ugui.standard_styler.params.tooltip.delay = 0
        ugui.button({
            uid = 5,
            rectangle = ctx.data.rect,
            text = 'Hello World!',
            tooltip = ctx.data.tooltip,
        })
        ugui.end_frame()

        ctx.assert_eq(ctx.data.expected.x, tooltip_rect.x)
        ctx.assert_eq(ctx.data.expected.y, tooltip_rect.y)
        ctx.assert_eq(ctx.data.expected.width, tooltip_rect.width)
        ctx.assert_eq(ctx.data.expected.height, tooltip_rect.height)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'delay_works',
    params = {
        {
            delay = 0.2,
        },
        {
            delay = 0.5,
        },
    },
    func = function(ctx)
        local tooltip_rect
        BreitbandGraphics.fill_rectangle = function(rectangle, color)
            if color == ugui.standard_styler.params.menu.back[ugui.visual_states.normal] then
                tooltip_rect = rectangle
            end
        end

        ugui.standard_styler.params.tooltip.delay = ctx.data.delay
        local time = 0
        os.clock = function()
            return time
        end

        ugui.begin_frame({
            mouse_position = {x = 1, y = 1},
            wheel = 0,
            is_primary_down = false,
            key_events = {},
        })
        ugui.button({
            uid = 5,
            rectangle = {x = 0, y = 0, width = 10, height = 10},
            text = 'Hello World!',
            tooltip = 'tooltip',
        })
        ugui.end_frame()

        ctx.assert(tooltip_rect == nil)

        tooltip_rect = nil
        time = ugui.standard_styler.params.tooltip.delay + 1

        ugui.begin_frame({
            mouse_position = {x = 1, y = 1},
            wheel = 0,
            is_primary_down = false,
            key_events = {},
        })
        ugui.button({
            uid = 5,
            rectangle = {x = 0, y = 0, width = 10, height = 10},
            text = 'Hello World!',
            tooltip = 'tooltip',
        })
        ugui.end_frame()

        ctx.assert(tooltip_rect ~= nil)
    end,
}

return group
