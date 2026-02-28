--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@type ControlRegistryEntry
ugui.registry.listbox = {
    ---@param control ListBox
    validate = function(control)
        ugui.internal.assert(type(control.items) == 'table', 'expected items to be table')
        ugui.internal.assert(type(control.selected_index) == 'number' or type(control.selected_index) == 'nil',
            'expected selected_index to be number or nil')
        ugui.internal.assert(type(control.horizontal_scroll) == 'nil' or type(control.horizontal_scroll) == 'boolean',
            'expected horizontal_scroll to be boolean or nil')
    end,
    ---@param control ListBox
    setup = function(control, data)
        if data.scroll_x == nil then
            data.scroll_x = 0
        end
        if data.scroll_y == nil then
            data.scroll_y = 0
        end
    end,
    ---@param control ListBox
    ---@return ControlReturnValue
    logic = function(control, data)
        data.selected_index = control.selected_index

        local prev_rect = ugui.internal.deep_clone(control.rectangle)
        local content_bounds = ugui.standard_styler.get_desired_listbox_content_bounds(control)
        local x_overflow = content_bounds.width > control.rectangle.width
        local y_overflow = content_bounds.height > control.rectangle.height

        if x_overflow then
            control.rectangle.height = control.rectangle.height - ugui.standard_styler.params.scrollbar.thickness
        end
        if y_overflow then
            control.rectangle.width = control.rectangle.width - ugui.standard_styler.params.scrollbar.thickness
        end

        if ugui.internal.mouse_captured_control == control.uid then
            -- Mouse-based selection
            local relative_y = ugui.internal.environment.mouse_position.y - control.rectangle.y
            local new_index = math.ceil((relative_y + (data.scroll_y *
                    ((ugui.standard_styler.params.listbox_item.height * #control.items) - control.rectangle.height))) /
                ugui.standard_styler.params.listbox_item.height)
            if new_index <= #control.items then
                data.selected_index = ugui.internal.clamp(new_index, 1, #control.items)
            end
        end

        -- Keyboard-based selection. FIXME: Why is this based on the mouse being inside it???
        -- FIXME: We want the separate concept of "keyboard focus" to be introduced
        if ugui.internal.mouse_captured_control == control.uid or BreitbandGraphics.is_point_inside_rectangle(ugui.internal.environment.mouse_position, control.rectangle) then
            for key, _ in pairs(ugui.internal.get_just_pressed_keys()) do
                if key == 'up' and data.selected_index ~= nil then
                    data.selected_index = ugui.internal.clamp(data.selected_index - 1, 1, #control.items)
                end
                if key == 'down' and data.selected_index ~= nil then
                    data.selected_index = ugui.internal.clamp(data.selected_index + 1, 1, #control.items)
                end
                if not y_overflow then
                    if key == 'pageup' or key == 'home' then
                        data.selected_index = 1
                    end
                    if key == 'pagedown' or key == 'end' then
                        data.selected_index = #control.items
                    end
                end
            end
        end

        if y_overflow and (ugui.internal.mouse_captured_control == control.uid or BreitbandGraphics.is_point_inside_rectangle(ugui.internal.environment.mouse_position, control.rectangle)) then
            local inc = 0
            if ugui.internal.is_mouse_wheel_up() then
                inc = -1 / #control.items
            end
            if ugui.internal.is_mouse_wheel_down() then
                inc = 1 / #control.items
            end

            for key, _ in pairs(ugui.internal.get_just_pressed_keys()) do
                if key == 'pageup' then
                    inc = -math.floor(control.rectangle.height / ugui.standard_styler.params.listbox_item.height) /
                        #control.items
                end
                if key == 'pagedown' then
                    inc = math.floor(control.rectangle.height / ugui.standard_styler.params.listbox_item.height) /
                        #control.items
                end
                if key == 'home' then
                    inc = -1
                end
                if key == 'end' then
                    inc = 1
                end
            end

            data.scroll_y = ugui.internal.clamp(data.scroll_y + inc, 0, 1)
        end

        control.rectangle = prev_rect

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
            control.selected_index ~= data.selected_index)

        return {
            primary = data.selected_index,
            meta = { signal_change = data.signal_change },
        }
    end,
    ---@param control ListBox
    draw = function(control)
        ugui.standard_styler.draw_listbox(control)
    end,
}

---Places a ListBox.
---@param control ListBox The control table.
---@return integer, Meta # The new selected index.
ugui.listbox = function(control)
    local content_bounds = ugui.standard_styler.get_desired_listbox_content_bounds(control)
    local x_overflow = content_bounds.width > control.rectangle.width
    local y_overflow = content_bounds.height > control.rectangle.height

    -- If we need scrollbars, we shrink the control rectangle to accomodate them.
    if x_overflow then
        control.rectangle.height = control.rectangle.height - ugui.standard_styler.params.scrollbar.thickness
    end
    if y_overflow then
        control.rectangle.width = control.rectangle.width - ugui.standard_styler.params.scrollbar.thickness
    end

    local result = ugui.control(control, 'listbox')
    local data = ugui.internal.control_data[control.uid]

    if x_overflow then
        data.scroll_x = ugui.scrollbar({
            uid = control.uid + 1,
            is_enabled = control.is_enabled,
            rectangle = {
                x = control.rectangle.x,
                y = control.rectangle.y + control.rectangle.height,
                width = control.rectangle.width,
                height = ugui.standard_styler.params.scrollbar.thickness,
            },
            value = data.scroll_x,
            ratio = 1 / (content_bounds.width / control.rectangle.width),
            z_index = control.z_index,
        })
    end

    if y_overflow then
        data.scroll_y = ugui.scrollbar({
            uid = control.uid + 2,
            is_enabled = control.is_enabled,
            rectangle = {
                x = control.rectangle.x + control.rectangle.width,
                y = control.rectangle.y,
                width = ugui.standard_styler.params.scrollbar.thickness,
                height = control.rectangle.height,
            },
            value = data.scroll_y,
            ratio = 1 / (content_bounds.height / control.rectangle.height),
            z_index = control.z_index,
        })
    end

    return result.primary, result.meta
end
