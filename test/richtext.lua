local group = {
    name = 'richtext',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'compute_rich_text_works',
    params = {
        {
            text = '[icon:arrow_left]',
            result = {size = {x = 12, y = 12}, segment_data = {{rectangle = {width = 12, y = 0, x = 0, height = 12}, segment = {type = 'icon', value = 'arrow_left'}}}},
        },
    },
    func = function(ctx)
        local result = ugui.standard_styler.compute_rich_text(ctx.data.text)
        ctx.assert_eq(result.size.x, ctx.data.result.size.x)
        ctx.assert_eq(result.size.y, ctx.data.result.size.y)
        for key, value in pairs(ctx.data.result.segment_data) do
            local data = result.segment_data[key]
            ctx.assert_eq(value.rectangle.x, data.rectangle.x)
            ctx.assert_eq(value.rectangle.y, data.rectangle.y)
            ctx.assert_eq(value.rectangle.width, data.rectangle.width)
            ctx.assert_eq(value.rectangle.height, data.rectangle.height)
            ctx.assert_eq(value.rectangle.height, data.rectangle.height)
            ctx.assert_eq(value.segment.type, data.segment.type)
            ctx.assert_eq(value.segment.value, data.segment.value)
        end
    end,
}

group.tests[#group.tests + 1] = {
    name = 'draw_rich_text_works',
    func = function(ctx)
        -- TODO: Implement
    end,
}

return group
