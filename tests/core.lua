local group = {
    name = 'core',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'uid_reuse_causes_error',
    func = function(ctx)
        local success = pcall(function()
            ugui.begin_frame({
                mouse_position = {x = 15, y = 15},
                wheel = 0,
                is_primary_down = true,
                held_keys = {},
            })
            ugui.button({
                uid = 5,
                rectangle = {x = 0, y = 0, width = 100, height = 20},
                text = 'Hello World!',
            })
            ugui.textbox({
                uid = 5,
                rectangle = {x = 0, y = 0, width = 100, height = 20},
                text = 'Hello World!',
            })
            ugui.end_frame()
        end)
        ctx.assert(not success, 'Uid reuse undetected')
    end,
}

group.tests[#group.tests + 1] = {
    name = 'malformed_control_generates_error',
    params = {
        {
            uid = nil,
            rectangle = {
                x = 5,
                y = 55,
                width = 90,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = nil,
                y = 55,
                width = 90,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = 5,
                y = nil,
                width = 90,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = 5,
                y = 55,
                width = nil,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = 5,
                y = 55,
                width = 90,
                height = nil,
            },
        },
    },
    func = function(ctx)
        local control_funcs = {
            ugui.button,
            ugui.toggle_button,
            ugui.carrousel_button,
            ugui.textbox,
            ugui.joystick,
            ugui.combobox,
            ugui.listbox,
            ugui.trackbar,
            ugui.scrollbar,
            ugui.menu,
        }

        local success, err = pcall(function()
            for _, control_func in pairs(control_funcs) do
                ugui.begin_frame({
                    mouse_position = {x = 15, y = 15},
                    wheel = 0,
                    is_primary_down = true,
                    held_keys = {},
                })
                control_func(ctx.data)
                ugui.end_frame()
            end
        end)

        ctx.assert(not success, 'Malformed control not detected')
    end,
}

group.tests[#group.tests + 1] = {
    name = 'unbalanced_frame_boundaries_causes_error',
    params = {
        {
            funcs = {
                ugui.begin_frame,
                ugui.begin_frame,
            },
            valid = false,
        },
        {
            funcs = {
                ugui.begin_frame,
                ugui.end_frame,
                ugui.end_frame,
            },
            valid = false,
        },
        {
            funcs = {
                ugui.end_frame,
            },
            valid = false,
        },
        {
            funcs = {
                ugui.begin_frame,
                ugui.end_frame,
            },
            valid = true,
        },
        {
            funcs = {
                ugui.begin_frame,
                ugui.end_frame,
                ugui.begin_frame,
                ugui.end_frame,
            },
            valid = true,
        },
    },
    func = function(ctx)
        local success, _ = pcall(function()
            for _, func in pairs(ctx.data.funcs) do
                func({})
            end
        end)
        ctx.assert_eq(ctx.data.valid, success)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'offscreen_hittest_is_ignored',
    params = {
        {
            name = "button",
            func = function ()
                return ugui.button({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    text = 'Hello World!',
                })
            end,
        },
        {
            name = "toggle_button",
            func = function ()
                return ugui.toggle_button({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    text = 'Hello World!',
                    is_checked = false,
                })
            end,
        },
        {
            name = "carrousel_button",
            func = function ()
                local i = ugui.carrousel_button({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    items = {"A", "B", "C"},
                    selected_index = 1
                })
                return i ~= 1
            end,
        },
        {
            name = "textbox",
            func = function ()
                ugui.textbox({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    text = "Hi",
                })
                return ugui.internal.captured_control == 5
            end,
        },
        {
            name = "joysitck",
            func = function ()
                local pos = ugui.joystick({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    position = {
                        x = 0,
                        y = 0,
                    },
                })
                return pos.x ~= 0 or pos.y ~= 0
            end,
        },
        {
            name = "trackbar",
            func = function ()
                local value = ugui.trackbar({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    value = 1
                })
                return value ~= 1
            end,
        },
        {
            name = "combobox",
            func = function ()
                ugui.combobox({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    items = {"A"},
                    selected_index = 1,
                })
                return ugui.internal.control_data[5].is_open == true
            end,
        },
        {
            name = "listbox",
            func = function ()
                local i = ugui.listbox({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    items = {"A", "B", "C"},
                    selected_index = 3,
                })
                return i ~= 3
            end,
        },
        {
            name = "scrollbar",
            func = function ()
                local val = ugui.scrollbar({
                    uid = 5,
                    rectangle = {x = -10, y = -10, width = 100, height = 20},
                    value = 1,
                    ratio = 1
                })
                return val ~= 1
            end,
        },
    },
    func = function(ctx)
        ugui.begin_frame({
            mouse_position = {x = -5, y = -5},
            wheel = 0,
            is_primary_down = false,
            held_keys = {},
        })
        ctx.data.func()
        ugui.end_frame()
        ugui.begin_frame({
            mouse_position = {x = -5, y = -5},
            wheel = 0,
            is_primary_down = true,
            held_keys = {},
        })
        local pressed = ctx.data.func()
        ugui.end_frame()
        ctx.assert(not pressed, string.format('Off-screen %s hittest succeded when it should have failed', ctx.data.name))
    end,
}

return group
