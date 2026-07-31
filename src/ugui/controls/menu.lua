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
        data.dismissed_latch = false
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

        if ugui.internal.is_mouse_just_down() and not BreitbandGraphics.is_point_inside_rectangle(ugui.internal.mouse_down_position, data.render_rect) then
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

        local max_text_width = 0
        for _, item in pairs(control.items) do
            local size = BreitbandGraphics.get_text_size(item.text, ugui.standard_styler.params.font_size,
                ugui.standard_styler.params.font_name)
            if size.width > max_text_width then
                max_text_width = size.width
            end
        end

        return {
            x = max_text_width + ugui.standard_styler.params.menu_item.left_padding + ugui.standard_styler.params.menu_item.right_padding,
            y = #control.items * ugui.standard_styler.params.menu_item.height,
        }
    end,
}

---Places a Menu.
---@param control Menu The control table.
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return MenuResult, Meta # The menu result.
ugui.menu = function(control, fn)
    control.z_index = control.z_index or 1000

    -- HACK: The old menu allowed width/height to be missing...
    if control.rectangle then
        control.margin = string.format('%fpx %fpx', control.rectangle.x, control.rectangle.y)
        control.size = 'auto'
        control.rectangle = nil
    end

    local results = {}
    local function place_recursive(parent_menu)
        local parent_data = ugui.internal.control_data[parent_menu.uid]

        if not parent_data.hovered_index then
            return
        end

        local item = parent_menu.items[parent_data.hovered_index]
        if not item.items then
            return
        end

        local menu = {
            uid = parent_menu.uid + 1,
            margin = string.format('%fpx %fpx', parent_data.render_rect.width - ugui.standard_styler.params.menu.overlap_size, (parent_data.hovered_index - 1) * ugui.standard_styler.params.menu_item.height),
            items = item.items,
            z_index = (parent_menu.z_index or 0) + 1,
        }

        table.insert(results, ugui.control(menu, 'menu', function()
            place_recursive(menu)
        end))
    end

    table.insert(results, ugui.control(control, 'menu', function()
        place_recursive(control)
    end))

    local data = ugui.internal.control_data[control.uid]

    -- If any menu returned an item, we go with that
    for _, result in pairs(results) do
        if result.primary.item then
            return {item = result.primary.item, dismissed = false}, {signal_change = ugui.signal_change_states.none}
        end
    end

    -- Dismissals are queued up for one frame
    for _, result in pairs(results) do
        if result.primary.dismissed then
            if data.dismissed_latch then
                data.dismissed_latch = false
                return {item = nil, dismissed = true}, {signal_change = ugui.signal_change_states.none}
            end
            data.dismissed_latch = true
        end
    end

    return {item = nil, dismissed = false}, {signal_change = ugui.signal_change_states.none}
end
