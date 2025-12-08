local group = {
    name = 'layout',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'unbalanced_panels_cause_error',
    func = function(ctx)
        local success = pcall(function()
            ugui.begin_frame({
                mouse_position = {x = 15, y = 15},
                wheel = 0,
                is_primary_down = true,
                held_keys = {},
            })
            ugui.push_stackpanel({})
            ugui.end_frame()
        end)
        ctx.assert(not success, 'Expected error due to unbalanced panels')
    end,
}

return group
