--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class ListBox : Control
---@field public items RichText[] The items contained in the control.
---@field public selected_index integer? The index of the currently selected item into the items array.
---@field public horizontal_scroll boolean? Whether horizontal scrolling will be enabled when items go beyond the width of the control. Will impact performance greatly, use with care.
---A listbox which allows the user to choose from a list of items.
---If the items don't fit in the control's bounds vertically, vertical scrolling will be enabled.
---If the items don't fit in the control's bounds horizontally, horizontal scrolling will be enabled if horizontal_scroll is true.
---The `rectangle` field might be mutated to accommodate the scrollbars.

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

        local one_item_scroll_y<const> = 1 / #control.items
        local one_page_scroll_y<const> = math.floor(control.rectangle.height / ugui.standard_styler.params.listbox_item.height) / #control.items
        local items_per_page<const> = math.floor(control.rectangle.height / ugui.standard_styler.params.listbox_item.height)

        -- FIXME: This is pretty weird... we should have a mechanism at the ugui core level for this
        local can_mouse_scroll = false
        if ugui.internal.mouse_captured_control == nil then
            can_mouse_scroll = ugui.internal.hovered_control == control.uid
        end
        if ugui.internal.mouse_captured_control == control.uid then
            can_mouse_scroll = true
        end

        local function index_from_y(y)
            return math.ceil((y + (data.scroll_y *
                    ((ugui.standard_styler.params.listbox_item.height * #control.items) - control.rectangle.height))) /
                ugui.standard_styler.params.listbox_item.height)
        end

        local function scroll_from_index(index)
            return (index - 1) * one_item_scroll_y
        end

        local function scroll_selected_index_into_view()
            -- TODO: Only scroll if the selected index is not already in view
            data.scroll_y = scroll_from_index(data.selected_index)
        end

        if ugui.internal.mouse_captured_control == control.uid then
            local relative_y = ugui.internal.environment.mouse_position.y - control.rectangle.y
            local new_index = index_from_y(relative_y)
            data.selected_index = new_index

            local overshoot = nil
            if relative_y > control.rectangle.height then
                overshoot = math.min(relative_y - control.rectangle.height, 50)
            end
            if relative_y < 0 then
                overshoot = math.min(relative_y, 50)
            end
            if overshoot ~= nil then
                data.scroll_y = data.scroll_y + one_item_scroll_y * ugui.internal.delta_time * overshoot * 2
            end
        end

        if can_mouse_scroll then
            if ugui.internal.is_mouse_wheel_up() then
                data.scroll_y = data.scroll_y - one_item_scroll_y
            end
            if ugui.internal.is_mouse_wheel_down() then
                data.scroll_y = data.scroll_y + one_item_scroll_y
            end
        end

        if ugui.internal.keyboard_captured_control == control.uid then
            for _, e in ipairs(ugui.internal.environment.key_events) do
                if not e.keycode or not e.pressed then
                    goto continue
                end

                if e.keycode == ugui.keycodes.VK_UP and data.selected_index ~= nil then
                    data.selected_index = ugui.internal.clamp(data.selected_index - 1, 1, #control.items)
                    scroll_selected_index_into_view()
                end
                if e.keycode == ugui.keycodes.VK_DOWN and data.selected_index ~= nil then
                    data.selected_index = ugui.internal.clamp(data.selected_index + 1, 1, #control.items)
                    scroll_selected_index_into_view()
                end
                if e.keycode == ugui.keycodes.VK_C and e.ctrl and data.selected_index ~= nil then
                    local item = control.items[data.selected_index]
                    ugui.STATIC_ENV.clipboard.set(item)
                end
                if e.keycode == ugui.keycodes.VK_PRIOR then
                    data.selected_index = data.selected_index - items_per_page
                    scroll_selected_index_into_view()
                end
                if e.keycode == ugui.keycodes.VK_NEXT then
                    data.selected_index = data.selected_index + items_per_page
                    scroll_selected_index_into_view()
                end
                if e.keycode == ugui.keycodes.VK_HOME then
                    data.selected_index = 1
                    scroll_selected_index_into_view()
                end
                if e.keycode == ugui.keycodes.VK_END then
                    data.selected_index = #control.items
                    scroll_selected_index_into_view()
                end

                ::continue::
            end
        end


        data.scroll_y = ugui.internal.clamp(data.scroll_y, 0, 1)
        if not y_overflow then
            data.scroll_y = 0
        end
        data.selected_index = ugui.internal.clamp(data.selected_index, 1, #control.items)

        control.rectangle = prev_rect

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
            control.selected_index ~= data.selected_index)

        return {
            primary = data.selected_index,
            meta = {signal_change = data.signal_change},
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
