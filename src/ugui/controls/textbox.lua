--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class TextBox : Control
---@field public text string The text contained in the textbox.
---A textbox which can be edited.


---Gets the index of the surrounding words in the specified text.
---@param text string The text to search.
---@param from integer The index to start searching from.
---@return integer, integer The index of the surrounding words.
local function surrounding_word_index(text, from)
    local lo = 1
    local hi = #text + 1

    local function classify(c)
        if c:match('%s') ~= nil then
            return 'space'
        end
        if c:match('[%w_]') ~= nil then
            return 'char'
        end
        return 'punct'
    end

    local initial_class = classify(text:sub(from, from))
    local initial_class_lo = classify(text:sub(from - 1, from - 1))

    for i = from - 1, 1, -1 do
        local class = classify(text:sub(i, i))
        if class ~= initial_class_lo then
            lo = i + 1
            break
        end
    end

    for i = from, #text, 1 do
        local class = classify(text:sub(i, i))
        if class ~= initial_class then
            hi = i
            break
        end
    end

    return lo, hi
end

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
        if data.scroll_offset == nil then
            data.scroll_offset = 0
        end
        if data.last_changed_anchor == nil then
            data.last_changed_anchor = 'caret'
        end
    end,
    ---@param control TextBox
    ---@return ControlReturnValue
    logic = function(control, data)
        data.text = control.text

        local index_at_mouse = ugui.internal.get_caret_index(data.text, data.scroll_offset, ugui.internal.environment.mouse_position.x - control.rectangle.x)

        -- If the control was just clicked, start a new selection.
        if ugui.internal.clicked_control == control.uid then
            data.caret_index = index_at_mouse
            data.selection_start = index_at_mouse
            data.selection_end = index_at_mouse
            data.last_changed_anchor = 'caret'
        end

        -- If we're dragging the control, extend the existing selection.
        if ugui.internal.mouse_captured_control == control.uid then
            data.selection_end = index_at_mouse
            data.last_changed_anchor = 'selection_end'
        end

        -- If we're capturing the keyboard, we process all the key presses.
        if ugui.internal.keyboard_captured_control == control.uid then
            for _, e in ipairs(ugui.internal.environment.key_events) do
                local has_selection = data.selection_start ~= data.selection_end
                if e.keycode and e.pressed then
                    local lower_selection = math.min(data.selection_start, data.selection_end)
                    local higher_selection = math.max(data.selection_start, data.selection_end)

                    if e.keycode == ugui.keycodes.VK_BACK then
                        if has_selection then
                            data.text = ugui.internal.remove_range(data.text, lower_selection, higher_selection)

                            data.caret_index = lower_selection
                            data.selection_start = lower_selection
                            data.selection_end = lower_selection
                            data.last_changed_anchor = 'caret'
                        else
                            local delete_index = data.caret_index - 1
                            data.text = ugui.internal.remove_at(data.text, delete_index)
                            data.caret_index = delete_index
                            data.last_changed_anchor = 'caret'
                        end
                    elseif e.keycode == ugui.keycodes.VK_LEFT then
                        if e.ctrl then
                            local prev_word, _ = surrounding_word_index(data.text, data.caret_index)
                            data.selection_start = prev_word
                            data.selection_end = prev_word
                            data.caret_index = prev_word
                        else
                            if has_selection then
                                data.selection_start = lower_selection
                                data.selection_end = lower_selection
                                data.caret_index = lower_selection
                                data.last_changed_anchor = 'caret'
                            else
                                data.caret_index = data.caret_index - 1
                                data.last_changed_anchor = 'caret'
                            end
                        end
                    elseif e.keycode == ugui.keycodes.VK_RIGHT then
                        if e.ctrl then
                            local _, next_word = surrounding_word_index(data.text, data.caret_index)
                            data.selection_start = next_word
                            data.selection_end = next_word
                            data.caret_index = next_word
                        else
                            if has_selection then
                                data.selection_start = higher_selection
                                data.selection_end = higher_selection
                                data.caret_index = higher_selection
                                data.last_changed_anchor = 'caret'
                            else
                                data.caret_index = data.caret_index + 1
                                data.last_changed_anchor = 'caret'
                            end
                        end
                    end

                    if e.keycode == ugui.keycodes.VK_C and e.ctrl and has_selection then
                        local selected_text = data.text:sub(lower_selection, higher_selection - 1)
                        ugui.STATIC_ENV.clipboard.set(selected_text)
                    end

                    if e.keycode == ugui.keycodes.VK_A and e.ctrl then
                        data.selection_start = 1
                        data.selection_end = #data.text + 1
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

                        data.last_changed_anchor = 'caret'
                    end
                    data.text = ugui.internal.insert_at(data.text, e.text, data.caret_index)
                    data.caret_index = data.caret_index + #e.text
                    data.last_changed_anchor = 'caret'
                end
            end
        end

        -- Clamp indices to valid ranges.
        data.scroll_offset = ugui.internal.clamp(data.scroll_offset, 0, #data.text + 1)
        data.caret_index = ugui.internal.clamp(data.caret_index, 1, #data.text + 1)
        data.selection_start = ugui.internal.clamp(data.selection_start, 1, #data.text + 1)
        data.selection_end = ugui.internal.clamp(data.selection_end, 1, #data.text + 1)

        local padding_x = ugui.standard_styler.params.textbox.padding.x
        local visible_width = control.rectangle.width - padding_x

        local function width_from_offset(offset, target_index)
            if target_index <= offset then
                return 0
            end

            local font_size = ugui.standard_styler.params.font_size
            local font_name = ugui.standard_styler.params.font_name

            local text_segment = data.text:sub(offset, target_index - 1)
            return BreitbandGraphics.get_text_size(
                text_segment,
                font_size,
                font_name
            ).width
        end

        local scroll_target = data.caret_index
        if data.last_changed_anchor == 'selection_start' then
            scroll_target = data.selection_start
        elseif data.last_changed_anchor == 'selection_end' then
            scroll_target = data.selection_end
        end

        -- If the chosen target is off the right edge, advance scroll_offset until it fits.
        local target_x = width_from_offset(data.scroll_offset, scroll_target)
        if target_x > visible_width then
            repeat
                data.scroll_offset = data.scroll_offset + 1
                target_x = width_from_offset(data.scroll_offset, scroll_target)
            until target_x <= visible_width or data.scroll_offset >= scroll_target
        end

        -- If the chosen target is off the left edge, snap scroll_offset to it.
        if scroll_target < data.scroll_offset then
            data.scroll_offset = scroll_target
        end

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
