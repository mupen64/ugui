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
    ---@param control ComboBox
    validate = function(control)
        ugui.internal.assert(type(control.items) == 'table', 'expected items to be table')
        ugui.internal.assert(type(control.selected_index) == 'number', 'expected selected_index to be number')
    end,
    ---@param control ComboBox
    setup = function(control, data)
        data.open = false
        data.hovered_index = control.selected_index
        data.searching = false
        data.search_text = ''
    end,
    ---@param control ComboBox
    ---@return ControlReturnValue
    logic = function(control, data)
        data.selected_index = control.selected_index

        if control.is_enabled == false then
            data.open = false
        end

        -- Only toggle on click if NOT editable (editable mode handles this via the button)
        if not control.editable and ugui.internal.clicked_control == control.uid then
            data.open = not data.open
        end

        if data.open and ugui.internal.is_mouse_just_down() and not ugui.internal.is_point_inside_control(ugui.internal.environment.mouse_position, control) then
            local content_bounds = ugui.standard_styler.get_desired_listbox_content_bounds(control)
            if not BreitbandGraphics.is_point_inside_rectangle(ugui.internal.environment.mouse_position, {
                    x = control.rectangle.x,
                    y = control.rectangle.y + control.rectangle.height,
                    width = control.rectangle.width,
                    height = content_bounds.height,
                }) then
                data.open = false
            end
        end

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
            control.selected_index ~= data.selected_index)

        return {
            primary = data.selected_index,
            meta = {signal_change = data.signal_change},
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
        local current_text = data.searching and data.search_text or control.items[data.selected_index]
        local search_text = ugui.textbox({
            uid = textbox_uid,
            rectangle = {
                x = control.rectangle.x,
                y = control.rectangle.y,
                width = control.rectangle.width - button_size,
                height = control.rectangle.height,
            },
            text = current_text,
        })

        if search_text ~= current_text then
            data.searching = true
            data.open = true
            data.search_text = search_text
        end

        if ugui.button({
                uid = button_uid,
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width - button_size,
                    y = control.rectangle.y,
                    width = button_size,
                    height = control.rectangle.height,
                },
                text = data.open and '[icon:arrow_up]' or '[icon:arrow_down]',
            }) then
            data.open = not data.open
        end
    end

    ---@type RichText[]
    local filtered_items = {}

    ---@type integer[] Maps filtered index -> original index
    local filtered_to_original = {}

    ---@type table<integer, integer> Maps original index -> filtered index
    local original_to_filtered = {}

    if data.searching then
        for i, item in ipairs(control.items) do
            if item:lower():find(data.search_text:lower(), 1, true) then
                table.insert(filtered_items, item)
                local filtered_index = #filtered_items
                filtered_to_original[filtered_index] = i
                original_to_filtered[i] = filtered_index
            end
        end
    else
        for i, item in ipairs(control.items) do
            table.insert(filtered_items, item)
            filtered_to_original[i] = i
            original_to_filtered[i] = i
        end
    end


    -- If there's only one item, select it automatically.
    if #filtered_items == 1 then
        data.selected_index = filtered_to_original[1]
        data.open = false
    end

    if #filtered_items == 0 then
        data.open = false
    end

    if data.open then
        -- Swap out the items so the measurement is correct...
        if data.searching then
            control.items = filtered_items
        end
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

        local filtered_selected = original_to_filtered[data.selected_index]
        if filtered_selected == nil and #filtered_items > 0 then
            filtered_selected = 1
        end

        local listbox_result, meta_listbox = ugui.listbox({
            uid = listbox_uid,
            rectangle = list_rect,
            items = filtered_items,
            selected_index = filtered_selected,
            plaintext = control.plaintext,
            z_index = math.maxinteger,
        })

        if meta_listbox.signal_change == ugui.signal_change_states.started then
            data.selected_index = filtered_to_original[listbox_result]
            data.searching = false
            data.search_text = ''
            data.open = false
        end
    end

    return data.selected_index, result.meta
end
