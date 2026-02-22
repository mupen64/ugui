local group = {
    name = 'spinner',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'no_min_no_max_doesnt_crash',
    func = function(ctx)
        ugui.begin_frame({
            mouse_position = {
                x = 10,
                y = 10,
            },
            wheel = 0,
            held_keys = {},
        })
        ugui.spinner({
            uid = 1,
            rectangle = {
                x = 10,
                y = 10,
                width = 190,
                height = 25,
            },
            value = 5,
        })
        ugui.end_frame()
        ctx.assert(true)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'no_value_interaction_doesnt_crash',
    func = function(ctx)
        ugui.begin_frame({
            mouse_position = {
                x = 15,
                y = 15,
            },
            wheel = 0,
            held_keys = {},
        })
        ugui.spinner({
            uid = 1,
            rectangle = {
                x = 10,
                y = 10,
                width = 190,
                height = 25,
            },
        })
        ugui.end_frame()


        ugui.begin_frame({
            mouse_position = {
                x = 15,
                y = 15,
            },
            wheel = 1,
            held_keys = {},
        })
        ugui.spinner({
            uid = 1,
            rectangle = {
                x = 10,
                y = 10,
                width = 190,
                height = 25,
            },
        })
        ugui.end_frame()


        ugui.begin_frame({
            mouse_position = {
                x = 15,
                y = 15,
            },
            wheel = 0,
            held_keys = {},
        })
        ugui.spinner({
            uid = 1,
            rectangle = {
                x = 10,
                y = 10,
                width = 190,
                height = 25,
            },
        })
        ugui.end_frame()
        
        ctx.assert(true)
    end,
}


return group
