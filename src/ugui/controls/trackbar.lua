--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

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
            if control.rectangle.width > control.rectangle.height then
                data.value = (ugui.internal.environment.mouse_position.x - control.rectangle.x) / control.rectangle
                    .width
            else
                data.value = (ugui.internal.environment.mouse_position.y - control.rectangle.y) /
                    control.rectangle.height
            end
        end

        data.value = ugui.internal.clamp(data.value, 0, 1)

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.value ~= data.value)

        return {
            primary = data.value,
            meta = { signal_change = data.signal_change },
        }
    end,
    ---@param control Trackbar
    draw = function(control)
        ugui.standard_styler.draw_trackbar(control)
    end,
}

---Places a Trackbar.
---@param control Trackbar The control table.
---@return number, Meta # The trackbar's new value.
ugui.trackbar = function(control)
    local result = ugui.control(control, 'trackbar')
    return result.primary, result.meta
end
