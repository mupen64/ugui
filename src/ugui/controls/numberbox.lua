--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

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

                local left = control.rectangle.width / 2 - full_width / 2
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
                control.rectangle.x)
        end

        if ugui.internal.keyboard_captured_control == control.uid then
            -- handle number key press
            for key, _ in pairs(ugui.internal.get_just_pressed_keys()) do
                local num_1 = tonumber(key)
                local num_2 = tonumber(key:sub(7))
                local digit = num_1 and num_1 or num_2

                if digit then
                    data.value = ugui.internal.set_digit(data.value, control.places, digit, data.caret_index)
                    data.caret_index = data.caret_index + 1
                end

                if key == 'left' then
                    data.caret_index = data.caret_index - 1
                end
                if key == 'right' then
                    data.caret_index = data.caret_index + 1
                end
                if key == 'up' then
                    increment_digit(data.caret_index, 1)
                end
                if key == 'down' then
                    increment_digit(data.caret_index, -1)
                end
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
            value = data.value,
            meta = { signal_change = data.signal_change },
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
        ugui.standard_styler.draw_edit_frame(control, control.rectangle, visual_state)

        BreitbandGraphics.draw_text2({
            text = text,
            rectangle = control.rectangle,
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

        local left = control.rectangle.width / 2 - full_width / 2

        local selected_char_rect = {
            x = control.rectangle.x + left + text_width_up_to_caret,
            y = control.rectangle.y,
            width = font_size / 2,
            height = control.rectangle.height,
        }

        if ugui.internal.keyboard_captured_control == control.uid then
            BreitbandGraphics.fill_rectangle(selected_char_rect, ugui.standard_styler.params.numberbox.selection)
            BreitbandGraphics.push_clip(selected_char_rect)
            BreitbandGraphics.draw_text2({
                text = text,
                rectangle = control.rectangle,
                color = BreitbandGraphics.invert_color(ugui.standard_styler.params.textbox.text[visual_state]),
                font_name = font_name,
                font_size = font_size,
                aliased = not ugui.standard_styler.params.cleartype,
            })
            BreitbandGraphics.pop_clip()
        end
    end,
}

---Places a NumberBox.
---@param control NumberBox The control table.
---@return integer, Meta # The new value.
ugui.numberbox = function(control)
    local _ = ugui.control(control, 'numberbox')
    local data = ugui.internal.control_data[control.uid]

    if control.show_negative then
        local negative_button_size = control.rectangle.width / 8

        control.rectangle = {
            x = control.rectangle.x + negative_button_size,
            y = control.rectangle.y,
            width = control.rectangle.width - negative_button_size,
            height = control.rectangle.height,
        }

        if ugui.button({
                uid = control.uid + 1,
                is_enabled = true,
                rectangle = {
                    x = control.rectangle.x - negative_button_size,
                    y = control.rectangle.y,
                    width = negative_button_size,
                    height = control.rectangle.height,
                },
                text = data.value >= 0 and '+' or '-',
            }) then
            data.value = -data.value
        end
    end

    return math.floor(data.value), data.meta
end
