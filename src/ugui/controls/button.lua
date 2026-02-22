---@type ControlRegistryEntry
ugui.registry.button = {
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
---@return boolean, Meta # Whether the button has been pressed.
ugui.button = function(control)
    local result = ugui.control(control, 'button')
    return result.primary, result.meta
end
