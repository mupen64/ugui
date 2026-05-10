--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class ScrollBar : Control
---@field public value number The scroll proportion in the range 0-1.
---@field public ratio number The overflow ratio, which is calculated by dividing the desired content dimensions by the relevant attached control's (e.g.: a listbox's) dimensions.
---A scrollbar which allows scrolling horizontally or vertically, depending on the control's dimensions.

---@type ControlRegistryEntry
ugui.registry.scrollbar = {
    place = function(control, fn)
        return ugui.internal.place_control(control, 'scrollbar', fn)
    end,
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

        local is_horizontal = data.render_rect.width > data.render_rect.height

        local thumb_size = is_horizontal
            and data.render_rect.width * control.ratio
            or data.render_rect.height * control.ratio

        if ugui.internal.mouse_captured_control == control.uid then
            local mouse_pos = ugui.internal.environment.mouse_position
            local mouse_down = ugui.internal.mouse_down_position

            if data.drag_offset == nil then
                if is_horizontal then
                    local thumb_start = ugui.internal.remap(data.value, 0, 1, 0, data.render_rect.width - thumb_size)
                    data.drag_offset = mouse_down.x - (data.render_rect.x + thumb_start)
                else
                    local thumb_start = ugui.internal.remap(data.value, 0, 1, 0, data.render_rect.height - thumb_size)
                    data.drag_offset = mouse_down.y - (data.render_rect.y + thumb_start)
                end
            end

            local current_pos = is_horizontal and (mouse_pos.x - data.render_rect.x - data.drag_offset) or (mouse_pos.y - data.render_rect.y - data.drag_offset)
            local track_length = (is_horizontal and data.render_rect.width or data.render_rect.height) - thumb_size

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
        local is_horizontal = data.render_rect.width > data.render_rect.height

        ---@type Rectangle
        local thumb_rectangle

        if is_horizontal then
            local scrollbar_width = data.render_rect.width * control.ratio
            local scrollbar_x = ugui.internal.remap(data.value, 0, 1, 0, data.render_rect.width - scrollbar_width)
            thumb_rectangle = {
                x = data.render_rect.x + scrollbar_x,
                y = data.render_rect.y,
                width = scrollbar_width,
                height = data.render_rect.height,
            }
        else
            local scrollbar_height = data.render_rect.height * control.ratio
            local scrollbar_y = ugui.internal.remap(data.value, 0, 1, 0, data.render_rect.height - scrollbar_height)
            thumb_rectangle = {
                x = data.render_rect.x,
                y = data.render_rect.y + scrollbar_y,
                width = data.render_rect.width,
                height = scrollbar_height,
            }
        end

        ugui.standard_styler.draw_scrollbar(control, thumb_rectangle)
    end,
}

---Places a ScrollBar.
---@param control ScrollBar The control table.
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return number, Meta # The new value.
ugui.scrollbar = function(control, fn)
    local result = ugui.control(control, 'scrollbar', fn)
    return result.primary, result.meta
end
