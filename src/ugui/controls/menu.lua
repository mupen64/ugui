--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class MenuItem
---@field public items MenuItem[]? The item's child items. If nil or empty, the item has no child items and is clickable.
---@field public enabled boolean? Whether the item is enabled. If nil or true, the item is enabled.
---@field public checked boolean? Whether the item is checked. If true, the item is checked.
---@field public text RichText The item's text.
---Represents an item inside of a Menu.

---@class MenuResult
---@field public item MenuItem? The item that was clicked, or nil if none was.
---@field public dismissed boolean Whether the menu was dismissed by clicking outside of it.

---@class Menu : Control
---@field public items MenuItem[] The items contained in the menu.
---A menu, which allows the user to choose from a list of items.

---@type ControlRegistryEntry
ugui.registry.menu = {
    ---@param control Menu
    validate = function(control)
        ugui.internal.assert(type(control.items) == 'table', 'expected items to be table')
    end,
    ---@param control Menu
    setup = function(control, data)
        data.hovered_index = nil
    end,
    ---@param control Menu
    ---@return ControlReturnValue
    logic = function(control, data)
        local result = {
            item = nil,
            dismissed = false,
        }

        if ugui.internal.hovered_control == control.uid then
            local i = math.floor((ugui.internal.environment.mouse_position.y - data.render_rect.y) /
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

        if result.item then
            result.dismissed = true
        end

        -- FIXME: Cursed flag... does this make sense?
        data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
            result.item ~= nil or result.dismissed)

        return {
            primary = result,
            meta = {signal_change = data.signal_change},
        }
    end,
    ---@param control Menu
    draw = function(control)
        local data = ugui.internal.control_data[control.uid]
        ugui.standard_styler.draw_menu(control, data.render_rect)
    end,
    measure = function(node)
        local control = node.control
        ---@cast control Menu

        local biggest_x = 0
        for _, item in pairs(control.items) do
            local size = BreitbandGraphics.get_text_size(item.text, ugui.standard_styler.params.font_size, ugui.standard_styler.params.font_name)
            biggest_x = math.max(biggest_x, size.width)
        end

        local x = biggest_x + ugui.standard_styler.params.menu_item.left_padding + ugui.standard_styler.params.menu_item.right_padding
        local y = #control.items * ugui.standard_styler.params.menu_item.height

        return {x = x, y = y}
    end,
}

---Places a Menu.
---**COMPATIBILITY**: For compatibility reasons, the menu will be, by default, parented to scene root unless `z_index` is non-nil.
---Child menus will be parented to their expected menu parent.
---@param control Menu The control table.
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return MenuResult, Meta # The menu result.
ugui.menu = function(control, fn)
    local has_z_index<const> = control.z_index ~= nil
    control.z_index = control.z_index or 1000

    -- Some scripts pass `rectangle` without `width`/`height`. We just deal with this by preemptively fixing this crap to use `margin` and `size`.
    if control.rectangle then
        control.margin = string.format('%fpx %fpx', control.rectangle.x, control.rectangle.y)
        control.rectangle = nil
    end

    local parent = has_z_index and ugui.internal.current_parent or ugui.internal.root
    local prev_parent = ugui.internal.current_parent
    ugui.internal.current_parent = parent

    local inner_result = {dismissed = false, item = nil}
    local result = ugui.control(control, 'menu', function()
        local data = ugui.internal.control_data[control.uid]

        if data.hovered_index ~= nil then
            local i = data.hovered_index
            local item = control.items[i]

            if item.items and item.enabled ~= false then
                local y = (i - 1) * ugui.standard_styler.params.menu_item.height
                local submenu_result = ugui.menu({
                    uid = control.uid + 1,
                    margin = string.format('100%%-%fpx %fpx', ugui.standard_styler.params.menu.overlap_size, y),
                    items = item.items,
                    z_index = 0,
                }).primary

                if submenu_result.item then
                    inner_result.dismissed = false
                    inner_result.item = submenu_result.item
                end
            end
        end

        if fn then fn() end
    end)
    local data = ugui.internal.control_data[control.uid]

    ugui.internal.current_parent = prev_parent

    if inner_result.dismissed then
        result.primary.dismissed = true
    end
    if inner_result.item then
        result.primary.item = inner_result.item
    end

    if result.primary.item or result.primary.dismissed then
        data.hovered_index = nil
    end

    -- COMPAT: BUG: We return the result wrapped in primary. This is to avoid breaking existing code, but it's just totally wrong.
    return result, result.meta
end
