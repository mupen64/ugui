--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Spinner : Control
---@field public value number The spinner's numerical value.
---@field public increment number? The increment applied when the + or - buttons are clicked (negated when - is clicked). If nil, 1 is assumed.
---@field public minimum_value number? The minimum value.
---@field public maximum_value number? The maximum value.
---@field public is_horizontal boolean? Whether the increment buttons are stacked horizontally.
---A spinner, consisting of a textbox and buttons for incrementing or decrementing a number.

---Places a Spinner.
---@param control Spinner The control table.
---@param fn ContentSlotCallback? The content slot callback.
---@return number, Meta # The new value.
ugui.spinner = function(control, fn)
    local textbox_uid<const> = control.uid + 1
    local button_1_uid<const> = control.uid + 2
    local button_2_uid<const> = control.uid + 4
    local button_3_uid<const> = control.uid + 6
    local button_4_uid<const> = control.uid + 8

    local increment<const> = control.increment or 1
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

    ugui.control(control, 'panel', function()
        local data = ugui.internal.control_data[control.uid]

        if control.is_horizontal then
            if ugui.button({
                    uid = button_1_uid,
                    is_enabled = not (value == control.minimum_value),
                    size = string.format('%fpx 100%%', ugui.standard_styler.params.spinner.button_size),
                    text = '-',
                })
            then
                value = clamp_value(value - increment)
            end

            if ugui.button({
                    uid = button_2_uid,
                    is_enabled = not (value == control.maximum_value),
                    size = string.format('%fpx 100%%', ugui.standard_styler.params.spinner.button_size),
                    margin = string.format('%fpx 0', ugui.standard_styler.params.spinner.button_size),
                    text = '+',
                })
            then
                value = clamp_value(value + increment)
            end
        else
            if ugui.button({
                    uid = button_1_uid,
                    is_enabled = not (value == control.minimum_value),
                    size = string.format('%fpx 50%%', ugui.standard_styler.params.spinner.button_size),
                    text = '-',
                })
            then
                value = clamp_value(value - increment)
            end

            if ugui.button({
                    uid = button_2_uid,
                    is_enabled = not (value == control.maximum_value),
                    size = string.format('%fpx 50%%', ugui.standard_styler.params.spinner.button_size),
                    margin = '0 50%',
                    text = '+',
                })
            then
                value = clamp_value(value + increment)
            end
        end

        local new_text = ugui.textbox({
            uid = textbox_uid,
            size = '100% 100%',
            margin = string.format('%fpx 0', ugui.standard_styler.params.spinner.button_size * (control.is_horizontal and 2 or 1)),
            text = tostring(value),
        })

        if tonumber(new_text) then
            value = clamp_value(tonumber(new_text))
        end

        if fn then fn() end
    end)

    local data = ugui.internal.control_data[control.uid]

    if control.is_enabled ~= false and (BreitbandGraphics.is_point_inside_rectangle(ugui.internal.environment.mouse_position, data.render_rect) or ugui.internal.mouse_captured_control == control.uid) then
        if ugui.internal.is_mouse_wheel_up() then
            value = clamp_value(value + increment)
        end
        if ugui.internal.is_mouse_wheel_down() then
            value = clamp_value(value - increment)
        end
    end

    data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.value ~= value)

    return clamp_value(value), {signal_change = data.signal_change}
end
