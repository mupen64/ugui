local group = {
    name = 'numberbox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'reacts_to_keyboard_and_mouse_input',
    params = {},
    func = function(ctx)
        -- TODO: Implement a test that clicks the numberbox, types numbers, moves the caret, scrolls the mouse wheel, etc...
    end,
}


return group
