---@type ControlRegistryEntry
ugui.registry.scrollbar = {
    ---@param control ScrollBar
    validate = function(control)
        ugui.internal.assert(type(control.value) == 'number', 'expected value to be number')
        ugui.internal.assert(type(control.ratio) == 'number', 'expected ratio to be number')
    end,
    ---@param control ScrollBar
    ---@return ControlReturnValue
    logic = function(control, data)
        data.value = control.value

        local is_horizontal = control.rectangle.width > control.rectangle.height

        if ugui.internal.mouse_captured_control == control.uid then
            local relative_mouse = {
                x = ugui.internal.environment.mouse_position.x - control.rectangle.x,
                y = ugui.internal.environment.mouse_position.y - control.rectangle.y,
            }
            local relative_mouse_down = {
                x = ugui.internal.mouse_down_position.x - control.rectangle.x,
                y = ugui.internal.mouse_down_position.y - control.rectangle.y,
            }
            local current
            local start
            if is_horizontal then
                current = relative_mouse.x / control.rectangle.width
                start = relative_mouse_down.x / control.rectangle.width
            else
                current = relative_mouse.y / control.rectangle.height
                start = relative_mouse_down.y / control.rectangle.height
            end
            data.value = ugui.internal.clamp(start + (current - start), 0, 1)
        end

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.value ~= data.value)

        return {
            primary = data.value,
            meta = { signal_change = data.signal_change },
        }
    end,
    ---@param control ScrollBar
    draw = function(control)
        local data = ugui.internal.control_data[control.uid]
        local is_horizontal = control.rectangle.width > control.rectangle.height

        ---@type Rectangle
        local thumb_rectangle

        if is_horizontal then
            local scrollbar_width = control.rectangle.width * control.ratio
            local scrollbar_x = ugui.internal.remap(data.value, 0, 1, 0, control.rectangle.width - scrollbar_width)
            thumb_rectangle = {
                x = control.rectangle.x + scrollbar_x,
                y = control.rectangle.y,
                width = scrollbar_width,
                height = control.rectangle.height,
            }
        else
            local scrollbar_height = control.rectangle.height * control.ratio
            local scrollbar_y = ugui.internal.remap(data.value, 0, 1, 0, control.rectangle.height - scrollbar_height)
            thumb_rectangle = {
                x = control.rectangle.x,
                y = control.rectangle.y + scrollbar_y,
                width = control.rectangle.width,
                height = scrollbar_height,
            }
        end

        ugui.standard_styler.draw_scrollbar(control, thumb_rectangle)
    end,
}

---Places a ScrollBar.
---@param control ScrollBar The control table.
---@return number, Meta # The new value.
ugui.scrollbar = function(control)
    local result = ugui.control(control, 'scrollbar')
    ---@cast result ControlReturnValue
    return result.primary, result.meta
end
