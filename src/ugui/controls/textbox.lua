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
            local just_pressed_keys = ugui.internal.get_just_pressed_keys()
            local has_selection = data.selection_start ~=
                data.selection_end

            for key, _ in pairs(just_pressed_keys) do
                local result = ugui.internal.handle_special_key(key, has_selection, data.text,
                    data.selection_start,
                    data.selection_end,
                    data.caret_index)


                -- special key press wasn't handled, we proceed to just insert the pressed character (or replace the selection)
                if not result.handled then
                    if #key ~= 1 then
                        goto continue
                    end

                    if has_selection then
                        local lower_selection = math.min(data.selection_start, data.selection_end)
                        local higher_selection = math.max(data.selection_start, data.selection_end)
                        data.text = ugui.internal.remove_range(data.text, lower_selection, higher_selection)
                        data.caret_index = lower_selection
                        data.selection_start = lower_selection
                        data.selection_end = lower_selection
                        data.text = ugui.internal.insert_at(data.text, key,
                            data.caret_index - 1)
                        data.caret_index = ugui.internal
                            .control_data[control.uid]
                            .caret_index + 1
                    else
                        data.text = ugui.internal.insert_at(data.text, key,
                            data.caret_index - 1)
                        data.caret_index = ugui.internal
                            .control_data[control.uid]
                            .caret_index + 1
                    end

                    goto continue
                end

                data.caret_index = result.caret_index
                data.selection_start = result.selection_start
                data.selection_end = result.selection_end
                data.text = result.text

                ::continue::
            end
        end

        data.caret_index = ugui.internal.clamp(data.caret_index, 1, #data.text + 1)

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change, control.text ~= data.text)

        return {
            primary = data.text,
            meta = { signal_change = data.signal_change },
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
