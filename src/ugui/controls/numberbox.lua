--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class NumberBox : Control
---@field public value integer The value.
---@field public places integer The amount of digits the value is padded to.
---@field public show_negative boolean? Whether a button for viewing and toggling the value's sign is shown. If nil, false is assumed.
---A numberbox, which allows modifying a number by typing or by adjusting its individual digits.

---@type ControlRegistryEntry
ugui.registry.numberbox = {
    ---@param control NumberBox
    validate = function(control)
        ugui.internal.assert(type(control.value) == 'number', 'expected value to be number')
        ugui.internal.assert(type(control.places) == 'number', 'expected places to be number')
        ugui.internal.assert(type(control.show_negative) == 'boolean' or type(control.show_negative) == 'nil',
            'expected show_negative to be boolean or nil')
    end,
    ---@param control NumberBox
    setup = function(control, data)
        data.caret_index = 1
    end,
    ---@param control NumberBox
    ---@return ControlReturnValue
    logic = function(control, data)
        local prev_value_negative = control.value < 0
        data.value = math.abs(control.value)

        local function get_caret_index_at_relative_x(x)
            local font_size = ugui.standard_styler.params.font_size * ugui.standard_styler.params.numberbox.font_scale
            local font_name = ugui.standard_styler.params.monospace_font_name
            local text = string.format('%0' .. tostring(control.places) .. 'd', data.value)

            -- award for most painful basic geometry
            local full_width = BreitbandGraphics.get_text_size(text,
                font_size,
                font_name).width

            local positions = {}
            for i = 1, #text, 1 do
                local width = BreitbandGraphics.get_text_size(text:sub(1, i),
                    font_size,
                    font_name).width

                local left = data.render_rect.width / 2 - full_width / 2
                positions[#positions + 1] = width + left
            end

            for i = #positions, 1, -1 do
                if x > positions[i] then
                    return ugui.internal.clamp(i + 1, 1, #positions)
                end
            end
            return 1
        end

        local function increment_digit(index, value)
            data.value = ugui.internal.set_digit(data.value, control.places,
                ugui.internal.get_digit(data.value, control.places, index) + value, index)
        end

        if ugui.internal.clicked_control == control.uid then
            data.caret_index = get_caret_index_at_relative_x(ugui.internal.environment.mouse_position.x -
                data.render_rect.x)
        end

        if ugui.internal.keyboard_captured_control == control.uid then
            -- handle number key press
            for _, e in ipairs(ugui.internal.environment.key_events) do
                if e.keycode and e.pressed then
                    if e.keycode == ugui.keycodes.VK_LEFT then
                        data.caret_index = data.caret_index - 1
                    end
                    if e.keycode == ugui.keycodes.VK_RIGHT then
                        data.caret_index = data.caret_index + 1
                    end
                    if e.keycode == ugui.keycodes.VK_UP then
                        increment_digit(data.caret_index, 1)
                    end
                    if e.keycode == ugui.keycodes.VK_DOWN then
                        increment_digit(data.caret_index, -1)
                    end
                    if e.keycode == ugui.keycodes.VK_C and e.ctrl then
                        local digit = ugui.internal.get_digit(data.value, control.places, data.caret_index)
                        ugui.STATIC_ENV.clipboard.set(tostring(digit))
                    end
                end
                if e.text then
                    -- accept only digit characters for insertion/paste
                    local digits = e.text:match('^%d+$')
                    if not digits then
                        goto continue
                    end

                    -- clamp/truncate so caret_index + #digits - 1 does not exceed control.places
                    local max_digits = control.places - data.caret_index + 1
                    if max_digits <= 0 then
                        goto continue
                    end
                    if #digits > max_digits then
                        digits = digits:sub(1, max_digits)
                    end

                    data.value = ugui.internal.set_digit_range(data.value, control.places, digits, data.caret_index)
                    data.caret_index = data.caret_index + #digits
                end
                ::continue::
            end

            if ugui.internal.is_mouse_wheel_up() then
                increment_digit(data.caret_index, 1)
            end
            if ugui.internal.is_mouse_wheel_down() then
                increment_digit(data.caret_index, -1)
            end
        end

        data.caret_index = ugui.internal.clamp(data.caret_index, 1, control.places)

        if prev_value_negative then
            data.value = -math.abs(data.value)
        end

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.value ~= data.value)

        return {
            primary = data.value,
            meta = {signal_change = data.signal_change},
        }
    end,
    ---@param control NumberBox
    draw = function(control)
        local data = ugui.internal.control_data[control.uid]
        local font_size = ugui.standard_styler.params.font_size * ugui.standard_styler.params.numberbox.font_scale
        local font_name = ugui.standard_styler.params.monospace_font_name
        local text = string.format('%0' .. tostring(control.places) .. 'd', math.abs(control.value))

        local visual_state = ugui.get_visual_state(control)
        if ugui.internal.keyboard_captured_control == control.uid then
            visual_state = ugui.visual_states.active
        end
        ugui.standard_styler.draw_edit_frame(control, data.render_rect, visual_state)

        BreitbandGraphics.draw_text2({
            text = text,
            rectangle = data.render_rect,
            color = ugui.standard_styler.params.textbox.text[visual_state],
            font_name = font_name,
            font_size = font_size,
            aliased = not ugui.standard_styler.params.cleartype,
        })

        local text_width_up_to_caret = BreitbandGraphics.get_text_size(
            text:sub(1, data.caret_index - 1),
            font_size,
            font_name).width

        local full_width = BreitbandGraphics.get_text_size(text,
            font_size,
            font_name).width

        local left = data.render_rect.width / 2 - full_width / 2

        local selected_char_rect = {
            x = data.render_rect.x + left + text_width_up_to_caret,
            y = data.render_rect.y,
            width = font_size / 2,
            height = data.render_rect.height,
        }

        if ugui.internal.keyboard_captured_control == control.uid then
            BreitbandGraphics.fill_rectangle(selected_char_rect, ugui.standard_styler.params.numberbox.selection)
            BreitbandGraphics.push_clip(selected_char_rect)
            BreitbandGraphics.draw_text2({
                text = text,
                rectangle = data.render_rect,
                color = BreitbandGraphics.invert_color(ugui.standard_styler.params.textbox.text[visual_state]),
                font_name = font_name,
                font_size = font_size,
                aliased = not ugui.standard_styler.params.cleartype,
            })
            BreitbandGraphics.pop_clip()
        end
    end,
    measure = function(node)
        local control = node.control
        ---@cast control NumberBox

        local text = string.format('%0' .. tostring(control.places) .. 'd', math.abs(control.value))
        local font_size = ugui.standard_styler.params.font_size * ugui.standard_styler.params.numberbox.font_scale
        local font_name = ugui.standard_styler.params.monospace_font_name
        local size = BreitbandGraphics.get_text_size(text, font_size, font_name)
        return {x = size.width, y = size.height}
    end,
}

---Places a NumberBox.
---@param control NumberBox The control table.
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return integer, Meta # The new value.
ugui.numberbox = function(control, fn)
    local button_uid<const> = control.uid + 1

    ugui.control(control, 'numberbox', function()
        local data = ugui.internal.control_data[control.uid]

        if control.show_negative then
            if ugui.button({
                    uid = button_uid,
                    is_enabled = true,
                    size = '24px 100%',
                    text = data.value >= 0 and '+' or '-',
                }) then
                data.value = -data.value
            end
        end

        if fn then
            fn()
        end
    end)

    local data = ugui.internal.control_data[control.uid]
    return math.floor(data.value), data.meta
end
