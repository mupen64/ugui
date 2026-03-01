--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@type ControlRegistryEntry
ugui.registry.scrollbar = {
    ---@param control ScrollBar
    validate = function(control)
        ugui.internal.assert(type(control.value) == 'number', 'expected value to be number')
        ugui.internal.assert(type(control.ratio) == 'number', 'expected ratio to be number')
    end,
    ---@param control ScrollBar
    setup = function(control, data)
        data.drag_offset = nil
    end,
    ---@param control ScrollBar
    ---@return ControlReturnValue
    logic = function(control, data)
        data.value = control.value

        local is_horizontal = control.rectangle.width > control.rectangle.height

        local thumb_size = is_horizontal
            and control.rectangle.width * control.ratio
            or control.rectangle.height * control.ratio

        if ugui.internal.mouse_captured_control == control.uid then
            local mouse_pos = ugui.internal.environment.mouse_position
            local mouse_down = ugui.internal.mouse_down_position

            if data.drag_offset == nil then
                if is_horizontal then
                    local thumb_start = ugui.internal.remap(data.value, 0, 1, 0, control.rectangle.width - thumb_size)
                    data.drag_offset = mouse_down.x - (control.rectangle.x + thumb_start)
                else
                    local thumb_start = ugui.internal.remap(data.value, 0, 1, 0, control.rectangle.height - thumb_size)
                    data.drag_offset = mouse_down.y - (control.rectangle.y + thumb_start)
                end
            end

            local current_pos = is_horizontal and (mouse_pos.x - control.rectangle.x - data.drag_offset) or (mouse_pos.y - control.rectangle.y - data.drag_offset)
            local track_length = (is_horizontal and control.rectangle.width or control.rectangle.height) - thumb_size

            data.value = ugui.internal.clamp(current_pos / track_length, 0, 1)
        else
            data.drag_offset = nil
        end

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.value ~= data.value)

        return {
            primary = data.value,
            meta = {signal_change = data.signal_change},
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
