--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---Sizes the control based on the biggest child.
---@param node SceneNode
---@return Vector2
function ugui.internal.measure_biggest(node)
    local biggest = {x = 0, y = 0}
    for _, child in pairs(node.children) do
        local size = ugui.internal.measure(child)
        biggest.x = math.max(biggest.x, size.x)
        biggest.y = math.max(biggest.y, size.y)
    end
    return biggest
end

---Sizes the control based on a stack layout.
---@param node SceneNode
---@return Vector2
function ugui.internal.measure_stack(node)
    local accumulator = {x = 0, y = 0}
    local biggest = {x = 0, y = 0}
    for _, child in pairs(node.children) do
        local size = ugui.internal.measure(child)
        accumulator.x = accumulator.x + size.x
        accumulator.y = accumulator.y + size.y
        biggest.x = math.max(biggest.x, size.x)
        biggest.y = math.max(biggest.y, size.y)
    end

    local horizontal_size = {x = accumulator.x, y = biggest.y}
    local vertical_size = {x = biggest.x, y = accumulator.y}

    local direction = node.control.direction or 0
    local x = ugui.internal.lerp(horizontal_size.x, vertical_size.x, direction)
    local y = ugui.internal.lerp(horizontal_size.y, vertical_size.y, direction)
    return {x = x, y = y}
end

---Arranges the control's children in a stack layout.
---@param node SceneNode
function ugui.internal.arrange_stack(node)
    local accumulator = {x = 0, y = 0}

    for _, child in pairs(node.children) do
        local child_data = ugui.internal.control_data[child.control.uid]

        local direction = node.control.direction or 0
        local x = ugui.internal.lerp(accumulator.x, 0, direction)
        local y = ugui.internal.lerp(0, accumulator.y, direction)

        -- FIXME: Don't clobber user margin here of course, we should have a better mechanism
        child.control.margin = string.format('%fpx %fpx', x, y)

        accumulator.x = accumulator.x + child_data.natural_size.x
        accumulator.y = accumulator.y + child_data.natural_size.y
    end
end

---Measures the specified node.
---@param node SceneNode
---@return Vector2
function ugui.internal.measure(node)
    -- We cache the natural sizes per-frame because they can be REALLY expensive to compute and we'd churn through these up to like 5 times depending on depth.
    if ugui.internal.control_data[node.control.uid].natural_size then
        return ugui.internal.control_data[node.control.uid].natural_size
    end

    local registry_entry = ugui.registry[node.type]

    local revert_styler_mixin = ugui.internal.apply_styler_mixin(node.control)
    local size
    if registry_entry.measure then
        size = registry_entry.measure(node)
    else
        if node.control.layout and node.control.layout == 'stack' then
            return ugui.internal.measure_stack(node)
        end

        return ugui.internal.measure_biggest(node)
    end
    revert_styler_mixin()

    local padding = node.control.padding and ugui.internal.resolve_unit2(node.control.padding, node) or {x = 0, y = 0}

    size.x = size.x + padding.x * 2
    size.y = size.y + padding.y * 2

    ugui.internal.control_data[node.control.uid].natural_size = size
    return size
end

function ugui.internal.layout()
    ugui.internal.foreach_node_from_root(function(node)
        ugui.internal.control_data[node.control.uid].natural_size = nil
    end)

    ugui.internal.foreach_node_from_root(function(node)
        ugui.internal.control_data[node.control.uid].natural_size = ugui.internal.measure(node)
    end)

    local function resolve_margins_and_sizes()
        ugui.internal.foreach_node_from_root(function(node)
            local control = node.control
            if control.margin then
                local pos = ugui.internal.resolve_unit2(control.margin, node)
                control.rectangle.x = pos.x
                control.rectangle.y = pos.y
            end
            if control.size then
                local size = ugui.internal.resolve_unit2(control.size, node)
                control.rectangle.width = size.x
                control.rectangle.height = size.y
            end
        end)
    end

    resolve_margins_and_sizes()

    -- This one is nuts: we have to emulate a flex-col with wrapping before we have an actual implementation for it...
    -- And even better that we have to feed content_rect back to it so it can return that...
    -- Absolutely NUTS design, this control's needs to be EXECUTED before 4.0.0
    --
    -- oh we also need to re-run the margin/size computation pass...
    ugui.internal.foreach_node_from_root(function(node)
        local data = ugui.internal.control_data[node.control.uid]

        if node.type == 'panel' and data.is_tab_control then
            local revert_styler_mixin = ugui.internal.apply_styler_mixin(node.control)

            local child_uid = node.control.uid + 1
            local x = 0
            local y = 0

            for _, __ in pairs(node.control.items) do
                local child_data = ugui.internal.control_data[child_uid]
                local child_node = ugui.internal.find_node(child_uid)

                if x + child_data.natural_size.x > node.control.rectangle.width then
                    x = 0
                    y = y + ugui.standard_styler.params.tabcontrol.rail_size + ugui.standard_styler.params.tabcontrol.gap_y
                end

                child_node.control.margin = string.format('%fpx %fpx', x, y)

                x = x + child_data.natural_size.x + ugui.standard_styler.params.tabcontrol.gap_x

                child_uid = child_uid + 2
            end

            data.rail_height = y + ugui.standard_styler.params.tabcontrol.rail_size - node.control.rectangle.y

            revert_styler_mixin()
        end

        if node.control.layout and node.control.layout == 'stack' then
            ugui.internal.arrange_stack(node)
        end
    end)

    resolve_margins_and_sizes()

    ugui.internal.foreach_node_from_root(function(node)
        local control = node.control
        local parent = node.parent

        local parent_rect = parent and parent.control.rectangle or {x = 0, y = 0, width = 0, height = 0}

        local min_x<const> = parent_rect.x
        local max_x<const> = min_x + parent_rect.width - control.rectangle.width

        local min_y<const> = parent_rect.y
        local max_y<const> = min_y + parent_rect.height - control.rectangle.height

        local align = ugui.internal.resolve_alignment2(control.align)
        local x_offset<const> = ugui.internal.remap(align.x, 0, 1, min_x, max_x)
        local y_offset<const> = ugui.internal.remap(align.y, 0, 1, min_y, max_y)

        control.rectangle.x = control.rectangle.x + x_offset
        control.rectangle.y = control.rectangle.y + y_offset
    end)

    ugui.internal.foreach_node_from_root(function(node)
        local data = ugui.internal.control_data[node.control.uid]
        data.render_rect = {x = node.control.rectangle.x, y = node.control.rectangle.y, width = node.control.rectangle.width, height = node.control.rectangle.height}
    end)

    -- HACK: We need to manipulate various controls to emulate a flex layout... it's only coming in a future pr lol
    ugui.internal.foreach_node_from_root(function(node)
        local data = ugui.internal.control_data[node.control.uid]

        if node.type == 'listbox' then
            local x_overflow<const> = data.natural_size.x > data.render_rect.width
            local y_overflow<const> = data.natural_size.y > data.render_rect.height
            local scrollbar_1_uid<const> = node.control.uid + 1
            local scrollbar_2_uid<const> = node.control.uid + 2
            local scrollbar_1_data = ugui.internal.control_data[scrollbar_1_uid]
            local scrollbar_2_data = ugui.internal.control_data[scrollbar_2_uid]

            if x_overflow and scrollbar_1_data then
                data.render_rect.width = data.render_rect.width - ugui.standard_styler.params.scrollbar.thickness
            end
            if y_overflow and scrollbar_2_data then
                data.render_rect.height = data.render_rect.height - ugui.standard_styler.params.scrollbar.thickness
            end
        end

        if node.type == 'numberbox' and node.control.show_negative then
            local button_uid<const> = node.control.uid + 1
            local button_data<const> = ugui.internal.control_data[button_uid]
            data.render_rect.x = data.render_rect.x + button_data.render_rect.width
            data.render_rect.width = data.render_rect.width - button_data.render_rect.width
        end

        -- Overflow avoidance: shift the X/Y position to avoid going out of bounds
        if node.type == 'menu' then
            local parent_is_menu = node.parent.control.type == 'menu'
            local parent_render_rect = ugui.internal.control_data[node.parent.control.uid].render_rect

            if data.render_rect.x + data.render_rect.width > ugui.internal.environment.window_size.x then
                if parent_is_menu then
                    data.render_rect.x = parent_render_rect.x - data.render_rect.width +
                        ugui.standard_styler.params.menu.overlap_size
                else
                    data.render_rect.x = data.render_rect.x -
                        (data.render_rect.x + data.render_rect.width - ugui.internal.environment.window_size.x)
                end
            end
            if data.render_rect.y + data.render_rect.height > ugui.internal.environment.window_size.y then
                data.render_rect.y = data.render_rect.y -
                    (data.render_rect.y + data.render_rect.height - ugui.internal.environment.window_size.y)
            end
        end

        if node.type == 'panel' and data.is_tab_control then
            data.content_rect = {x = data.render_rect.x, y = data.render_rect.y + data.rail_height, width = data.render_rect.width, height = data.render_rect.height - data.rail_height}
        end
    end)
end
