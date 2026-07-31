--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Trackbar : Control
---@field public value number The current value in the range 0-1.
---A trackbar which can have its value adjusted.

---@type ControlRegistryEntry
ugui.registry.trackbar = {
    ---@param control Trackbar
    validate = function(control)
        ugui.internal.assert(type(control.value) == 'number', 'expected position to be number')
    end,
    ---@param control Trackbar
    ---@return ControlReturnValue
    logic = function(control, data)
        data.value = control.value

        if ugui.internal.mouse_captured_control == control.uid then
            if data.render_rect.width > data.render_rect.height then
                data.value = (ugui.internal.environment.mouse_position.x - data.render_rect.x) / data.render_rect
                    .width
            else
                data.value = (ugui.internal.environment.mouse_position.y - data.render_rect.y) /
                    data.render_rect.height
            end
        end

        data.value = ugui.internal.clamp(data.value, 0, 1)

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.value ~= data.value)

        return {
            primary = data.value,
            meta = {signal_change = data.signal_change},
        }
    end,
    ---@param control Trackbar
    draw = function(control)
        ugui.standard_styler.draw_trackbar(control)
    end,
}

---Places a Trackbar.
---@param control Trackbar The control table.
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return number, Meta # The trackbar's new value.
ugui.trackbar = function(control, fn)
    local result = ugui.control(control, 'trackbar', fn)
    return result.primary, result.meta
end
