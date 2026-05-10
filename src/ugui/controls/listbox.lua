--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class ListBox : Control
---@field public items RichText[] The items contained in the control.
---@field public selected_index integer? The index of the currently selected item into the items array. If `nil`, no item is selected.
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

        local one_item_scroll_y<const> = 1 / #control.items
        local items_per_page<const> = math.floor(data.render_rect.height / ugui.standard_styler.params.listbox_item.height)

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
                    ((ugui.standard_styler.params.listbox_item.height * #control.items) - data.render_rect.height))) /
                ugui.standard_styler.params.listbox_item.height)
        end

        local function scroll_selected_index_into_view()
            if data.selected_index == nil then
                return
            end

            local item_height = ugui.standard_styler.params.listbox_item.height
            local scroll_range = (item_height * #control.items) - data.render_rect.height

            if scroll_range <= 0 then
                return
            end

            local scroll_offset_px = data.scroll_y * scroll_range
            local first_visible = math.floor(scroll_offset_px / item_height) + 1
            local last_visible = math.floor((scroll_offset_px + data.render_rect.height) / item_height)

            if data.selected_index < first_visible then
                data.scroll_y = (data.selected_index - 1) * item_height / scroll_range
            elseif data.selected_index > last_visible then
                data.scroll_y = (data.selected_index * item_height - data.render_rect.height) / scroll_range
            end
        end

        if ugui.internal.mouse_captured_control == control.uid then
            local relative_y = ugui.internal.environment.mouse_position.y - data.render_rect.y
            local new_index = index_from_y(relative_y)
            data.selected_index = new_index

            local overshoot = nil
            if relative_y > data.render_rect.height then
                overshoot = relative_y - data.render_rect.height
            end
            if relative_y < 0 then
                overshoot = relative_y
            end
            if overshoot ~= nil then
                overshoot = ugui.internal.clamp(overshoot, -50, 50)
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
                if e.keycode == ugui.keycodes.VK_PRIOR and data.selected_index ~= nil then
                    data.selected_index = data.selected_index - items_per_page
                    scroll_selected_index_into_view()
                end
                if e.keycode == ugui.keycodes.VK_NEXT and data.selected_index ~= nil then
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
        if data.selected_index ~= nil then
            data.selected_index = ugui.internal.clamp(data.selected_index, 1, #control.items)
        end

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
    measure = function(node)
        local control = node.control
        ---@cast control ListBox

        -- Since horizontal content bounds measuring is expensive, we only do this if explicitly enabled.
        local max_width = 0
        if control.horizontal_scroll == true then
            for _, value in pairs(control.items) do
                local size = ugui.standard_styler.compute_rich_text(value, control.plaintext, ugui.standard_styler.params.font_name, ugui.standard_styler.params.font_size).size

                if size.x > max_width then
                    max_width = size.x
                end
            end
        else
            max_width = 100
        end

        return {
            x = max_width,
            y = ugui.standard_styler.params.listbox_item.height * #control.items,
        }
    end,
}

---Places a ListBox.
---@param control ListBox The control table.
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return integer, Meta # The new selected index.
ugui.listbox = function(control, fn)
    local scrollbar_1_uid<const> = control.uid + 1
    local scrollbar_2_uid<const> = control.uid + 2

    local result = ugui.control(control, 'listbox', fn)
    local data = ugui.internal.control_data[control.uid]

    local x_overflow<const> = data.natural_size.x > data.render_rect.width and control.horizontal_scroll
    local y_overflow<const> = data.natural_size.y > data.render_rect.height

    if not x_overflow then
        data.scroll_x = 0
    end
    if not y_overflow then
        data.scroll_y = 0
    end

    if x_overflow then
        data.scroll_x = ugui.scrollbar({
            uid = scrollbar_1_uid,
            is_enabled = control.is_enabled,
            rectangle = {
                x = data.render_rect.x,
                y = data.render_rect.y + data.render_rect.height,
                width = data.render_rect.width,
                height = ugui.standard_styler.params.scrollbar.thickness,
            },
            value = data.scroll_x,
            ratio = 1 / (data.natural_size.x / data.render_rect.width),
            z_index = control.z_index,
        })
    end

    if y_overflow then
        data.scroll_y = ugui.scrollbar({
            uid = scrollbar_2_uid,
            is_enabled = control.is_enabled,
            rectangle = {
                x = data.render_rect.x + data.render_rect.width,
                y = data.render_rect.y,
                width = ugui.standard_styler.params.scrollbar.thickness,
                height = data.render_rect.height,
            },
            value = data.scroll_y,
            ratio = 1 / (data.natural_size.y / data.render_rect.height),
            z_index = control.z_index,
        })
    end

    return result.primary, result.meta
end
