---@type ControlRegistryEntry
ugui.registry.combobox = {
    ---@param control ComboBox
    validate = function(control)
        ugui.internal.assert(type(control.items) == 'table', 'expected items to be table')
        ugui.internal.assert(type(control.selected_index) == 'number', 'expected selected_index to be number')
    end,
    ---@param control ComboBox
    setup = function(control, data)
        if data.open == nil then
            data.open = false
        end
        if data.hovered_index == nil then
            data.hovered_index = control.selected_index
        end
    end,
    ---@param control ComboBox
    ---@return ControlReturnValue
    logic = function(control, data)
        data.selected_index = control.selected_index

        if control.is_enabled == false then
            data.open = false
        end

        if ugui.internal.clicked_control == control.uid then
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
            meta = { signal_change = data.signal_change },
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

        data.selected_index = ugui.listbox({
            uid = control.uid + 1,
            rectangle = list_rect,
            items = control.items,
            selected_index = data.selected_index,
            plaintext = control.plaintext,
            z_index = math.maxinteger,
        })
    end

    return data.selected_index, result.meta
end
