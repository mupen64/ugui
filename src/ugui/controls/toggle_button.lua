--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@type ControlRegistryEntry
ugui.registry.toggle_button = {
    ---@param control ToggleButton
    validate = function(control)
        ugui.registry.button.validate(control)
        ugui.internal.assert(type(control.is_checked) == 'boolean', 'expected is_checked to be boolean')
    end,
    ---@param control ToggleButton
    ---@return ControlReturnValue
    logic = function(control, data)
        data.is_checked = control.is_checked

        local pressed = ugui.internal.clicked_control == control.uid

        if pressed then
            data.is_checked = not data.is_checked
        end

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, pressed)

        return {
            primary = data.is_checked,
            meta = {
                signal_change = data.signal_change,
            },
        }
    end,
    ---@param control ToggleButton
    draw = function(control)
        ugui.standard_styler.draw_togglebutton(control)
    end,
}

---Places a ToggleButton.
---@param control ToggleButton The control table.
---@return boolean, Meta # The new check state.
ugui.toggle_button = function(control)
    local result = ugui.control(control, 'toggle_button')
    return result.primary, result.meta
end
