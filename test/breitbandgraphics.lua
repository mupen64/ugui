local group = {
    name = 'breitbandgraphics',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'draw_text_fit_calls_d2d_draw_text_with_correct_font_size',
    params = {
        {
            rectangle = {x = 244, y = 195, width = 137, height = 204},
            font_size = {12, 12, 12},

        },
        {
            rectangle = {x = 204, y = 212, width = 39, height = 266},
            font_size = {7.8, 5.92, 8.83},
        },
        {
            rectangle = {y = 144, x = 304, height = 9, width = 274},
            font_size = {7.2, 7.2, 7.2},
        },
    },
    func = function(ctx)
        local d2d_draw_text = d2d.draw_text


        local i = 1
        d2d.draw_text = function(rect_x,
            rect_y,
            rect_r,
            rect_b,
            text,
            font_name,
            font_size,
            d_weight,
            d_style,
            d_horizontal_alignment,
            d_vertical_alignment,
            d_options,
            brush)
            ctx.assert_eq(math.floor(ctx.data.font_size[i]), math.floor(font_size))
            i = i + 1
        end

        BreitbandGraphics.draw_text(ctx.data.rectangle, 'start', 'start', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.params.font_size, ugui.standard_styler.params.font_name, '(start, start)')
        BreitbandGraphics.draw_text(ctx.data.rectangle, 'center', 'center', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.params.font_size, ugui.standard_styler.params.font_name, '(center, center)')
        BreitbandGraphics.draw_text(ctx.data.rectangle, 'end', 'end', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.params.font_size, ugui.standard_styler.params.font_name, '(end, end)')

        d2d.draw_text = d2d_draw_text
    end,
}

group.tests[#group.tests + 1] = {
    name = 'draw_text2_fit_calls_d2d_draw_text_with_correct_font_size',
    params = {
        {
            rectangle = {x = 244, y = 195, width = 137, height = 204},
            font_size = {12, 12, 12},

        },
        {
            rectangle = {x = 204, y = 212, width = 39, height = 266},
            font_size = {7.8, 5.92, 8.83},
        },
        {
            rectangle = {y = 144, x = 304, height = 9, width = 274},
            font_size = {7.2, 7.2, 7.2},
        },
    },
    func = function(ctx)
        local d2d_draw_text = d2d.draw_text


        local i = 1
        d2d.draw_text = function(rect_x,
            rect_y,
            rect_r,
            rect_b,
            text,
            font_name,
            font_size,
            d_weight,
            d_style,
            d_horizontal_alignment,
            d_vertical_alignment,
            d_options,
            brush)
            ctx.assert_eq(math.floor(ctx.data.font_size[i]), math.floor(font_size))
            i = i + 1
        end

        BreitbandGraphics.draw_text2({
            text = '(start, start)',
            rectangle = ctx.data.rectangle,
            align_x = BreitbandGraphics.alignment.start,
            align_y = BreitbandGraphics.alignment.start,
            color = BreitbandGraphics.colors.black,
            font_name = ugui.standard_styler.params.font_name,
            font_size = ugui.standard_styler.params.font_size,
            fit = true,
        })
        BreitbandGraphics.draw_text2({
            text = '(center, center)',
            rectangle = ctx.data.rectangle,
            align_x = BreitbandGraphics.alignment.center,
            align_y = BreitbandGraphics.alignment.center,
            color = BreitbandGraphics.colors.black,
            font_name = ugui.standard_styler.params.font_name,
            font_size = ugui.standard_styler.params.font_size,
            fit = true,
        })
        BreitbandGraphics.draw_text2({
            text = '(end, end)',
            rectangle = ctx.data.rectangle,
            align_x = BreitbandGraphics.alignment['end'],
            align_y = BreitbandGraphics.alignment['end'],
            color = BreitbandGraphics.colors.black,
            font_name = ugui.standard_styler.params.font_name,
            font_size = ugui.standard_styler.params.font_size,
            fit = true,
        })

        d2d.draw_text = d2d_draw_text
    end,
}

local color_mega_map = {
    {
        color = {r = 0, g = 0, b = 0},
        text = '#000000',
        array_color = {0, 0, 0},
        arary_float_color = {0.0, 0.0, 0.0},
    },
    {
        color = {r = 255, g = 0, b = 0},
        text = '#FF0000',
        array_color = {255, 0, 0},
        arary_float_color = {1.0, 0.0, 0.0},
    },
    {
        color = {r = 0, g = 255, b = 0},
        text = '#00FF00',
        array_color = {0, 255, 0},
        arary_float_color = {0.0, 1.0, 0.0},
    },
    {
        color = {r = 0, g = 0, b = 255},
        text = '#0000FF',
        array_color = {0, 0, 255},
        arary_float_color = {0.0, 0.0, 1.0},
    },
    {
        color = {r = 255, g = 255, b = 0},
        text = '#FFFF00',
        array_color = {255, 255, 0},
        arary_float_color = {1.0, 1.0, 0.0},
    },
    {
        color = {r = 0, g = 255, b = 255},
        text = '#00FFFF',
        array_color = {0, 255, 255},
        arary_float_color = {0.0, 1.0, 1.0},
    },
    {
        color = {r = 255, g = 0, b = 255},
        text = '#FF00FF',
        array_color = {255, 0, 255},
        arary_float_color = {1.0, 0.0, 1.0},
    },
    {
        color = {r = 192, g = 192, b = 192},
        text = '#C0C0C0',
        array_color = {192, 192, 192},
        arary_float_color = {0.75, 0.75, 0.75},
    },
    {
        color = {r = 128, g = 128, b = 128},
        text = '#808080',
        array_color = {128, 128, 128},
        arary_float_color = {0.5, 0.5, 0.5},
    },
    {
        color = {r = 128, g = 0, b = 0},
        text = '#800000',
        array_color = {128, 0, 0},
        arary_float_color = {0.5, 0.0, 0.0},
    },
    {
        color = {r = 128, g = 128, b = 0},
        text = '#808000',
        array_color = {128, 128, 0},
        arary_float_color = {0.5, 0.5, 0.0},
    },
    {
        color = {r = 0, g = 128, b = 0},
        text = '#008000',
        array_color = {0, 128, 0},
        arary_float_color = {0.0, 0.5, 0.0},
    },
    {
        color = {r = 128, g = 0, b = 128},
        text = '#800080',
        array_color = {128, 0, 128},
        arary_float_color = {0.5, 0.0, 0.5},
    },
    {
        color = {r = 0, g = 128, b = 128},
        text = '#008080',
        array_color = {0, 128, 128},
        arary_float_color = {0.0, 0.5, 0.5},
    },
    {
        color = {r = 0, g = 0, b = 128},
        text = '#000080',
        array_color = {0, 0, 128},
        arary_float_color = {0.0, 0.0, 0.5},
    },
}

group.tests[#group.tests + 1] = {
    name = 'color_to_hex_works',
    params = color_mega_map,
    func = function(ctx)
        local result = BreitbandGraphics.color_to_hex(ctx.data.color)
        ctx.assert_eq(ctx.data.text, result)
        local roundtripped = BreitbandGraphics.hex_to_color(result)
        ctx.assert_eq(ctx.data.color.r, roundtripped.r)
        ctx.assert_eq(ctx.data.color.g, roundtripped.g)
        ctx.assert_eq(ctx.data.color.b, roundtripped.b)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'hex_to_color_works',
    params = color_mega_map,
    func = function(ctx)
        local color = BreitbandGraphics.hex_to_color(ctx.data.text)
        ctx.assert_eq(ctx.data.color.r, color.r)
        ctx.assert_eq(ctx.data.color.g, color.g)
        ctx.assert_eq(ctx.data.color.b, color.b)
        local roundtripped = BreitbandGraphics.color_to_hex(color)
        ctx.assert_eq(ctx.data.text, roundtripped)        
    end,
}

group.tests[#group.tests + 1] = {
    name = 'repeated_to_color_works',
    params = {
        {
            value = 0,
            expected = {r = 0, g = 0, b = 0},
        },
        {
            value = 128,
            expected = {r = 128, g = 128, b = 128},
        },
        {
            value = 255,
            expected = {r = 255, g = 255, b = 255},
        },
    },
    func = function(ctx)
        local color = BreitbandGraphics.repeated_to_color(ctx.data.value)
        ctx.assert_eq(ctx.data.value, color.r)
        ctx.assert_eq(ctx.data.value, color.g)
        ctx.assert_eq(ctx.data.value, color.b)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'invert_color_works',
    params = {
        {
            color = {r = 0, g = 0, b = 0},
            expected = {r = 255, g = 255, b = 255},
        },
        {
            color = {r = 255, g = 255, b = 255},
            expected = {r = 0, g = 0, b = 0},
        },
        {
            color = {r = 255, g = 255, b = 255, a = 255},
            expected = {r = 0, g = 0, b = 0, a = 255},
        },
        {
            color = {r = 255, g = 255, b = 255, a = 0},
            expected = {r = 0, g = 0, b = 0, a = 0},
        },
    },
    func = function(ctx)
        local color = BreitbandGraphics.invert_color(ctx.data.color)
        ctx.assert_eq(ctx.data.expected.r, color.r)
        ctx.assert_eq(ctx.data.expected.g, color.g)
        ctx.assert_eq(ctx.data.expected.b, color.b)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'is_point_inside_rectangle_works',
    params = {
        {
            point = {x = 0, y = 0},
            rectangle = {x = 0, y = 0, width = 10, height = 10},
            expected = false,
        },
        {
            point = {x = 1, y = 1},
            rectangle = {x = 0, y = 0, width = 10, height = 10},
            expected = true,
        },
        {
            point = {x = 11, y = 11},
            rectangle = {x = 0, y = 0, width = 10, height = 10},
            expected = false,
        },
    },
    func = function(ctx)
        ctx.assert_eq(ctx.data.expected, BreitbandGraphics.is_point_inside_rectangle(ctx.data.point, ctx.data.rectangle))
    end,
}

group.tests[#group.tests + 1] = {
    name = 'is_point_inside_any_rectangle_works',
    params = {
        {
            point = {x = 0, y = 0},
            rectangles = {
                {x = 0, y = 0, width = 10, height = 10},
                {x = 20, y = 0, width = 10, height = 10},
            },
            expected = false,
        },
        {
            point = {x = 1, y = 1},
            rectangles = {
                {x = 0, y = 0, width = 10, height = 10},
                {x = 20, y = 0, width = 10, height = 10},
            },
            expected = true,
        },
        {
            point = {x = 5, y = 5},
            rectangles = {
                {x = 0, y = 0, width = 10, height = 10},
                {x = 2, y = 0, width = 10, height = 10},
            },
            expected = true,
        },
        {
            point = {x = 5, y = 5},
            rectangles = {},
            expected = false,
        },
    },
    func = function(ctx)
        ctx.assert_eq(ctx.data.expected, BreitbandGraphics.is_point_inside_any_rectangle(ctx.data.point, ctx.data.rectangles))
    end,
}

group.tests[#group.tests + 1] = {
    name = 'inflate_rectangle_works',
    params = {
        {
            rectangle = {
                x = 5,
                y = 5,
                width = 10,
                height = 10,
            },
            by = 5,
            expected = {
                x = 0,
                y = 0,
                width = 20,
                height = 20,
            },
        },
        {
            rectangle = {
                x = 5,
                y = 5,
                width = 10,
                height = 10,
            },
            by = -5,
            expected = {
                x = 10,
                y = 10,
                width = 0,
                height = 0,
            },
        },
        {
            rectangle = {
                x = 5,
                y = 5,
                width = 10,
                height = 10,
            },
            by = 0,
            expected = {
                x = 5,
                y = 5,
                width = 10,
                height = 10,
            },
        },
    },
    func = function(ctx)
        local rectangle = BreitbandGraphics.inflate_rectangle(ctx.data.rectangle, ctx.data.by)
        ctx.assert_eq(ctx.data.expected.x, rectangle.x)
        ctx.assert_eq(ctx.data.expected.y, rectangle.y)
        ctx.assert_eq(ctx.data.expected.width, rectangle.width)
        ctx.assert_eq(ctx.data.expected.height, rectangle.height)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'color_to_float_works',
    params = {
        {
            color = {
                r = 0,
                g = 0,
                b = 0,
                a = 0,
            },
            expected = {
                r = 0,
                g = 0,
                b = 0,
                a = 0,
            },
        },
        {
            color = {
                r = 255,
                g = 255,
                b = 255,
                a = 255,
            },
            expected = {
                r = 1,
                g = 1,
                b = 1,
                a = 1,
            },
        },
        {
            color = {
                r = 128,
                g = 128,
                b = 128,
                a = 128,
            },
            expected = {
                r = 0.5,
                g = 0.5,
                b = 0.5,
                a = 0.5,
            },
        },
        {
            color = {
                r = 128,
                g = 128,
                b = 128,
            },
            expected = {
                r = 0.5,
                g = 0.5,
                b = 0.5,
                a = 1,
            },
        },
    },
    func = function(ctx)
        local color = BreitbandGraphics.color_to_float(ctx.data.color)

        ctx.assert(math.abs(ctx.data.expected.r - color.r) < 0.01)
        ctx.assert(math.abs(ctx.data.expected.g - color.g) < 0.01)
        ctx.assert(math.abs(ctx.data.expected.b - color.b) < 0.01)
    end,
}

return group
