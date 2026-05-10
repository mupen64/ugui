--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Button : Control
---@field public text RichText The text displayed on the button.
---A button which can be clicked.

---@type ControlRegistryEntry
ugui.registry.button = {
    ---@param control Button
    place = function(control, fn)
        return ugui.internal.place_control(control, 'button', function()
            local visual_state = ugui.get_visual_state(control)
            ugui.label({
                uid = control.uid + 1,
                text = control.text,
                align = '50%',
                color = ugui.standard_styler.params.button.text[visual_state],
            })
            if fn then
                fn()
            end
        end)
    end,
    ---@param control Button
    validate = function(control)
        ugui.internal.assert(type(control.text) == 'string', 'expected text to be string')
    end,
    ---@param control Button
    ---@return ControlReturnValue
    logic = function(control, data)
        local pressed = ugui.internal.clicked_control == control.uid

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, pressed)

        return {
            primary = pressed,
            meta = {
                signal_change = data.signal_change,
            },
        }
    end,
    ---@param control Button
    draw = function(control)
        ugui.standard_styler.draw_button(control)
    end,
}

---Places a Button.
---@param control Button The control table.
---@param fn ContentSlotCallback? The content slot callback.
---@return boolean, Meta # Whether the button has been pressed.
ugui.button = function(control, fn)
    local result = ugui.control(control, 'button', fn)
    return result.primary, result.meta
end
