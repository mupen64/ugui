--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@type ControlRegistryEntry
ugui.registry.menu = {
    ---@param control Menu
    validate = function(control)
        ugui.internal.assert(type(control.items) == 'table', 'expected items to be table')
    end,
    ---@param control Menu
    setup = function(control, data)
        data.dismissed = 0
    end,
    ---@param control Menu
    ---@return ControlReturnValue
    logic = function(control, data)
        local function reset_hovered_index_for_all_child_menus(uid, items)
            if ugui.internal.control_data[uid] then
                ugui.internal.control_data[uid].hovered_index = nil
            end
            for _, item in pairs(items) do
                if item.items then
                    reset_hovered_index_for_all_child_menus(uid + 1, item.items)
                end
            end
        end

        local result = {
            item = nil,
            dismissed = false,
        }

        -- We want to delay returning the dismissed state by a frame because we don't get to handle inputs otherwise,
        -- so we turn the dismissed flag into a tristate.
        if data.dismissed == 2 then
            data.dismissed = 0
            result.dismissed = true
        end

        if data.dismissed == 1 then
            data.dismissed = 2
        end

        if ugui.internal.is_mouse_just_down() and not BreitbandGraphics.is_point_inside_rectangle(ugui.internal.mouse_down_position, control.rectangle) then
            data.dismissed = 1
        end

        if ugui.internal.hovered_control == control.uid then
            reset_hovered_index_for_all_child_menus(control.uid, control.items)

            local i = math.floor((ugui.internal.environment.mouse_position.y - control.rectangle.y) /
                ugui.standard_styler.params.menu_item.height) + 1
            data.hovered_index = ugui.internal.clamp(i, 1, #control.items)
        end

        if ugui.internal.clicked_control == control.uid then
            local item = control.items[data.hovered_index]

            -- Only child-less items can be clicked
            if item.enabled ~= false and (item.items == nil or #item.items == 0) then
                result.item = item
            end
        end

        if result.dismissed or result.item then
            reset_hovered_index_for_all_child_menus(control.uid, control.items)
        end

        -- FIXME: Cursed flag... does this make sense?
        data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
            result.item ~= nil or result.dismissed)

        return {
            primary = result,
            meta = { signal_change = data.signal_change },
        }
    end,
    ---@param control Menu
    draw = function(control)
        ugui.standard_styler.draw_menu(control, control.rectangle)
    end,
}

---Places a Menu.
---@param control Menu The control table.
---@return MenuResult, Meta # The menu result.
ugui.menu = function(control)
    control.z_index = control.z_index or 1000

    -- We adjust the dimensions with what should fit the content
    local max_text_width = 0
    for _, item in pairs(control.items) do
        local size = BreitbandGraphics.get_text_size(item.text, ugui.standard_styler.params.font_size,
            ugui.standard_styler.params.font_name)
        if size.width > max_text_width then
            max_text_width = size.width
        end
    end

    control.rectangle.width = max_text_width + ugui.standard_styler.params.menu_item.left_padding +
        ugui.standard_styler.params.menu_item.right_padding
    control.rectangle.height = #control.items * ugui.standard_styler.params.menu_item.height

    -- Overflow avoidance: shift the X/Y position to avoid going out of bounds
    if control.rectangle.x + control.rectangle.width > ugui.internal.environment.window_size.x then
        -- If the menu has a parent and there's an overflow on the X axis, try snaking out of the situation by moving left of the menu
        if control.parent_rectangle then
            control.rectangle.x = control.parent_rectangle.x - control.rectangle.width +
                ugui.standard_styler.params.menu.overlap_size
        else
            control.rectangle.x = control.rectangle.x -
                (control.rectangle.x + control.rectangle.width - ugui.internal.environment.window_size.x)
        end
    end
    if control.rectangle.y + control.rectangle.height > ugui.internal.environment.window_size.y then
        control.rectangle.y = control.rectangle.y -
            (control.rectangle.y + control.rectangle.height - ugui.internal.environment.window_size.y)
    end

    local result = ugui.control(control, 'menu')
    local data = ugui.internal.control_data[control.uid]

    -- Show child menu if there's any hovered one
    if data.hovered_index ~= nil then
        local i = data.hovered_index
        local item = control.items[i]

        if item.items and item.enabled ~= false then
            local submenu_result = ugui.menu({
                uid = control.uid + 1,
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width - ugui.standard_styler.params.menu.overlap_size,
                    y = control.rectangle.y + ((i - 1) * ugui.standard_styler.params.menu_item.height),
                    width = 0,
                    height = 0,
                },
                items = item.items,
                z_index = (control.z_index or 0) + 1,
                parent_rectangle = ugui.internal.deep_clone(control.rectangle),
            })

            if submenu_result.item then
                result.dismissed = false
                result.item = submenu_result.item
            end
        end
    end

    return result, result.meta
end
