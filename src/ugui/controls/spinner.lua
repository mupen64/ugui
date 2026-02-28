--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---Places a Spinner.
---@param control Spinner The control table.
---@return number, Meta # The new value.
ugui.spinner = function(control)
    local _ = ugui.control(control, '')
    local data = ugui.internal.control_data[control.uid]

    local increment = control.increment or 1
    local value = control.value or 0

    local function clamp_value(value)
        if control.minimum_value and control.maximum_value then
            return ugui.internal.clamp(value, control.minimum_value, control.maximum_value)
        end

        if control.minimum_value then
            return math.max(value, control.minimum_value)
        end

        if control.maximum_value then
            return math.min(value, control.maximum_value)
        end

        return value
    end

    local textbox_rect = {
        x = control.rectangle.x,
        y = control.rectangle.y,
        width = control.rectangle.width - ugui.standard_styler.params.spinner.button_size * 2,
        height = control.rectangle.height,
    }

    local new_text = ugui.textbox({
        uid = control.uid + 1,
        rectangle = textbox_rect,
        text = tostring(value),
    })

    if tonumber(new_text) then
        value = clamp_value(tonumber(new_text))
    end

    if control.is_enabled ~= false
        and (BreitbandGraphics.is_point_inside_rectangle(ugui.internal.environment.mouse_position, textbox_rect) or ugui.internal.mouse_captured_control == control.uid)
    then
        if ugui.internal.is_mouse_wheel_up() then
            value = clamp_value(value + increment)
        end
        if ugui.internal.is_mouse_wheel_down() then
            value = clamp_value(value - increment)
        end
    end

    if control.is_horizontal then
        if (ugui.button({
                uid = control.uid + 2,
                is_enabled = not (value == control.minimum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width -
                        ugui.standard_styler.params.spinner.button_size * 2,
                    y = control.rectangle.y,
                    width = ugui.standard_styler.params.spinner.button_size,
                    height = control.rectangle.height,
                },
                text = '-',
            }))
        then
            value = clamp_value(value - increment)
        end

        if (ugui.button({
                uid = control.uid + 3,
                is_enabled = not (value == control.maximum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width -
                        ugui.standard_styler.params.spinner.button_size,
                    y = control.rectangle.y,
                    width = ugui.standard_styler.params.spinner.button_size,
                    height = control.rectangle.height,
                },
                text = '+',
            }))
        then
            value = clamp_value(value + increment)
        end
    else
        if (ugui.button({
                uid = control.uid + 2,
                is_enabled = not (value == control.maximum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width -
                        ugui.standard_styler.params.spinner.button_size * 2,
                    y = control.rectangle.y,
                    width = ugui.standard_styler.params.spinner.button_size * 2,
                    height = control.rectangle.height / 2,
                },
                text = '+',
            }))
        then
            value = clamp_value(value + increment)
        end

        if (ugui.button({
                uid = control.uid + 3,
                is_enabled = not (value == control.minimum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width -
                        ugui.standard_styler.params.spinner.button_size * 2,
                    y = control.rectangle.y + control.rectangle.height / 2,
                    width = ugui.standard_styler.params.spinner.button_size * 2,
                    height = control.rectangle.height / 2,
                },
                text = '-',
            }))
        then
            value = clamp_value(value - increment)
        end
    end

    data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.value ~= value)

    return clamp_value(value), { signal_change = data.signal_change }
end
