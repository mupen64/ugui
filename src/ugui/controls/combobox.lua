-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class ComboBox : Control
---@field public items RichText[] The items contained in the control.
---@field public selected_index integer? The index of the currently selected item into the items array. If nil, no item is selected.
---@field public editable boolean? Whether the user can type in the combobox to filter the items.
---A combobox which allows the user to choose from a list of items.

---@type ControlRegistryEntry
ugui.registry.combobox = {
    hittestable = nil,
    ---@param control ComboBox
    validate = function(control)
        ugui.internal.assert(type(control.items) == 'table', 'expected items to be table')
        ugui.internal.assert(type(control.selected_index) == 'number', 'expected selected_index to be number')
    end,
    ---@param control ComboBox
    setup = function(control, data)
        data.open = false
        data.was_open = false
        data.selected_index = control.selected_index
        data.quiet_selected_index = control.selected_index
        data.update_filter = false
        data.search_text = nil
        data.close_on_next_update = false
    end,
    ---@param control ComboBox
    ---@return ControlReturnValue
    logic = function(control, data)
        if control.is_enabled == false then
            data.open = false
        end

        -- Only toggle on click if NOT editable (editable mode handles this via the button)
        if not control.editable and ugui.internal.clicked_control == control.uid then
            data.open = not data.open
        end

        if data.open then
            -- allow confirming the selection with return when the control itself or the textbox captures keyboard input
            if ugui.internal.keyboard_captured_control == control.uid + (control.editable and 1 or 0) then
                for _, e in ipairs(ugui.internal.environment.key_events) do
                    if e.keycode == ugui.keycodes.VK_RETURN and e.pressed then
                        data.close_on_next_update = true
                    end
                end
            end
        end

        local selected_index = data.filtered_to_original and data.filtered_to_original[data.selected_index] or data.selected_index

        local signal_change = control.selected_index ~= selected_index
            and (data.open
                and (data.was_open and ugui.signal_change_states.ongoing or ugui.signal_change_states.started)
                or (data.was_open and ugui.signal_change_states.ended or ugui.signal_change_states.none))
            or ugui.signal_change_states.none

        if signal_change == ugui.signal_change_states.ended then
            data.searching = false
            data.search_text = nil
        elseif signal_change == ugui.signal_change_states.none then
            selected_index = control.selected_index
            if not control.editable then
                data.selected_index = selected_index
            end
        end
        data.was_open = data.open
        return {
            primary = selected_index,
            meta = {signal_change = signal_change},
        }
    end,
    ---@param control ComboBox
    draw = function(control)
        ugui.standard_styler.draw_combobox(control)
    end,
}


---Places a ComboBox.
---@param control ComboBox The control table.
---@return integer, Meta # The new selected index.
ugui.combobox = function(control)
    local result = ugui.control(control, 'combobox')
    local data = ugui.internal.control_data[control.uid]

    local textbox_uid<const> = control.uid + 1
    local button_uid<const> = control.uid + 2
    local listbox_uid<const> = control.uid + 3

    local button_size<const> = 30

    if control.editable then
        local selected_index = data.filtered_to_original and data.filtered_to_original[data.selected_index] or data.selected_index
        local current_text = (data.search_text or control.items[selected_index]) or ''
        local search_text = ugui.textbox({
            uid = textbox_uid,
            rectangle = {
                x = control.rectangle.x,
                y = control.rectangle.y,
                width = control.rectangle.width - button_size,
                height = control.rectangle.height,
            },
            is_enabled = control.is_enabled,
            text = current_text,
        })

        if ugui.button({
                uid = button_uid,
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width - button_size,
                    y = control.rectangle.y,
                    width = button_size,
                    height = control.rectangle.height,
                },
                is_enabled = control.is_enabled,
                text = data.open and '[icon:arrow_up]' or '[icon:arrow_down]',
            }) then
            data.open = not data.open
            data.update_filter = data.open
            data.search_text = current_text
            data.quiet_selected_index = 1
        end

        if search_text ~= current_text then
            data.update_filter = true
            data.open = true
            data.search_text = search_text
            data.quiet_selected_index = 1
        end
    end

    if data.open then
        local items_to_show = control.items

        if control.editable then
            if data.update_filter then
                data.update_filter = false
                ---@type RichText[]
                data.filtered_items = {}

                ---@type integer[]
                data.filtered_to_original = {}

                for i, item in ipairs(control.items) do
                    if item:lower():find(data.search_text:lower(), 1, true) then
                        table.insert(data.filtered_items, item)
                        local filtered_index = #data.filtered_items
                        data.filtered_to_original[filtered_index] = i
                        if control.selected_index == i then
                            data.selected_index = filtered_index
                        end
                    end
                end
            end

            items_to_show = data.filtered_items
            control.items = data.filtered_items
        else
            data.filtered_to_original = nil
        end

        if data.open then
            local content_bounds = ugui.standard_styler.get_desired_listbox_content_bounds(control)

            local width = control.rectangle.width
            if control.rectangle.x + width > ugui.internal.environment.window_size.x then
                width = ugui.internal.environment.window_size.x - control.rectangle.x
            end

            local height = content_bounds.height
            if control.rectangle.y + height > ugui.internal.environment.window_size.y then
                height = ugui.internal.environment.window_size.y - control.rectangle.y -
                    ugui.standard_styler.params.listbox_item.height * 2
            end

            local list_rect = {
                x = control.rectangle.x,
                y = control.rectangle.y + control.rectangle.height,
                width = width,
                height = height,
            }

            local restore = ugui.internal.keyboard_captured_control
            ugui.internal.keyboard_captured_control = listbox_uid
            data.quiet_selected_index = ugui.listbox({
                uid = listbox_uid,
                rectangle = list_rect,
                items = items_to_show,
                selected_index = data.quiet_selected_index,
                plaintext = control.plaintext,
                z_index = math.maxinteger,
            })
            ugui.internal.keyboard_captured_control = restore

            if data.close_on_next_update then
                data.open = false
                data.search_text = nil
                -- Commit the selection
                data.selected_index = data.filtered_to_original and data.filtered_to_original[data.quiet_selected_index] or data.quiet_selected_index
            end

            data.close_on_next_update =
                data.open
                and ugui.internal.is_mouse_just_down()
                and not ugui.internal.is_point_inside_control(ugui.internal.environment.mouse_position, control)
        end
    end

    return result.primary, result.meta
end
