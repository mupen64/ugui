--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@type ControlRegistryEntry
ugui.registry.textbox = {
    ---@param control TextBox
    validate = function(control)
        ugui.internal.assert(type(control.text) == 'string', 'expected text to be string')
    end,
    ---@param control TextBox
    setup = function(control, data)
        if data.caret_index == nil then
            data.caret_index = 1
        end
        if data.selection_start == nil then
            data.selection_start = 1
        end
        if data.selection_end == nil then
            data.selection_end = 1
        end
    end,
    ---@param control TextBox
    ---@return ControlReturnValue
    logic = function(control, data)
        data.text = control.text

        local index_at_mouse = ugui.internal.get_caret_index(data.text,
            ugui.internal.environment.mouse_position.x - control.rectangle.x)

        -- If the control was just clicked, start a new selection.
        if ugui.internal.clicked_control == control.uid then
            data.caret_index = index_at_mouse
            data.selection_start = index_at_mouse
            data.selection_end = index_at_mouse
        end

        -- If we're dragging the control, extend the existing selection.
        if ugui.internal.mouse_captured_control == control.uid then
            data.selection_end = index_at_mouse
        end

        -- If we're capturing the keyboard, we process all the key presses.
        if ugui.internal.keyboard_captured_control == control.uid then
            local has_selection = data.selection_start ~=
                data.selection_end

            for _, e in pairs(ugui.internal.environment.key_events) do
                if e.keycode and e.pressed then
                    local lower_selection = math.min(data.selection_start, data.selection_end)
                    local higher_selection = math.max(data.selection_start, data.selection_end)

                    if e.keycode == ugui.keycodes.VK_BACK then
                        if has_selection then
                            data.text = ugui.internal.remove_range(data.text, lower_selection, higher_selection)

                            data.caret_index = lower_selection
                            data.selection_start = lower_selection
                            data.selection_end = lower_selection
                        else
                            local delete_index = data.caret_index - 1
                            data.text = ugui.internal.remove_at(data.text, delete_index)
                            data.caret_index = delete_index
                        end
                    elseif e.keycode == ugui.keycodes.VK_LEFT then
                        if has_selection then
                            data.selection_start = lower_selection
                            data.selection_end = lower_selection
                            data.caret_index = lower_selection
                        else
                            data.caret_index = data.caret_index - 1
                        end
                    elseif e.keycode == ugui.keycodes.VK_RIGHT then
                        if has_selection then
                            data.selection_start = higher_selection
                            data.selection_end = higher_selection
                            data.caret_index = higher_selection
                        else
                            data.caret_index = data.caret_index + 1
                        end
                    end
                end

                if e.text then
                    if has_selection then
                        local lower_selection = math.min(data.selection_start, data.selection_end)
                        local higher_selection = math.max(data.selection_start, data.selection_end)

                        data.text = ugui.internal.remove_range(data.text, lower_selection, higher_selection)

                        data.caret_index = lower_selection
                        data.selection_start = lower_selection
                        data.selection_end = lower_selection
                    end
                    data.text = ugui.internal.insert_at(data.text, e.text, data.caret_index - 1)
                    data.caret_index = data.caret_index + 1
                end
            end
        end

        data.caret_index = ugui.internal.clamp(data.caret_index, 1, #data.text + 1)

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.text ~= data.text)

        return {
            primary = data.text,
            meta = {signal_change = data.signal_change},
        }
    end,
    ---@param control TextBox
    draw = function(control)
        ugui.standard_styler.draw_textbox(control)
    end,
}

---Places a TextBox.
---@param control TextBox The control table.
---@return string, Meta # The new text.
ugui.textbox = function(control)
    local result = ugui.control(control, 'textbox')
    return result.primary, result.meta
end
