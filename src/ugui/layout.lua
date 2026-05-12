--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class LayoutStrategy
---@field public measure fun(node: SceneNode, available_size: Vector2): Vector2 Measures the node's size.
---@field public arrange fun(node: SceneNode, slot: Rectangle): Rectangle[] Computes slots for the node's children.

---@type table<string, LayoutStrategy>
ugui.internal.layout_strategies = {
    biggest = {
        ---Fit the biggest child.
        measure = function(node, available_size)
            local biggest = {x = 0, y = 0}
            for _, child in pairs(node.children) do
                local size = ugui.internal.measure(child, available_size)
                biggest.x = math.max(biggest.x, size.x)
                biggest.y = math.max(biggest.y, size.y)
            end
            return biggest
        end,
        ---All children get all the space as a slot.
        arrange = function(node, slot)
            local slots = {}
            for _, child in pairs(node.children) do
                slots[#slots + 1] = {x = 0, y = 0, width = node.control.rectangle.width, height = node.control.rectangle.height}
            end
            return slots
        end,
    },
    stack = {
        measure = function(node, available_size)
            -- FIXME: Consider wrapping!
            local accumulator = {x = 0, y = 0}
            local biggest = {x = 0, y = 0}
            for _, child in pairs(node.children) do
                local size = ugui.internal.measure(child, available_size)
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
        end,
        arrange = function(node, slot)
            local direction<const> = node.control.direction or 0
            local wrap<const> = node.control.wrap or false

            local function arrange_horizontal()
                local accumulator = {x = 0, y = 0}
                local row_height = 0
                local slots = {}

                for _, child in pairs(node.children) do
                    local child_size = {
                        x = child.control.rectangle.x + child.control.rectangle.width,
                        y = child.control.rectangle.y + child.control.rectangle.height,
                    }

                    if wrap and accumulator.x + child_size.x > node.control.rectangle.width then
                        accumulator.x = 0
                        accumulator.y = accumulator.y + row_height
                        row_height = 0
                    end

                    slots[#slots + 1] = {
                        x = accumulator.x,
                        y = accumulator.y,
                        width = child_size.x,
                        height = child_size.y,
                    }

                    accumulator.x = accumulator.x + child_size.x
                    row_height = math.max(row_height, child_size.y)
                end

                return slots
            end

            local function arrange_vertical()
                local accumulator = {x = 0, y = 0}
                local column_width = 0
                local slots = {}

                for _, child in pairs(node.children) do
                    local child_size = {
                        x = child.control.rectangle.x + child.control.rectangle.width,
                        y = child.control.rectangle.y + child.control.rectangle.height,
                    }

                    if wrap and accumulator.y + child_size.y > node.control.rectangle.height then
                        accumulator.y = 0
                        accumulator.x = accumulator.x + column_width
                        column_width = 0
                    end

                    slots[#slots + 1] = {
                        x = accumulator.x,
                        y = accumulator.y,
                        width = child_size.x,
                        height = child_size.y,
                    }

                    accumulator.y = accumulator.y + child_size.y
                    column_width = math.max(column_width, child_size.x)
                end

                return slots
            end

            local horizontal_slots = arrange_horizontal()
            local vertical_slots = arrange_vertical()
            local slots = {}

            for i = 1, #horizontal_slots, 1 do
                local horizontal_slot = horizontal_slots[i]
                local vertical_slot = vertical_slots[i]

                slots[#slots + 1] = {
                    x = ugui.internal.lerp(horizontal_slot.x, vertical_slot.x, direction),
                    y = ugui.internal.lerp(horizontal_slot.y, vertical_slot.y, direction),
                    width = ugui.internal.lerp(horizontal_slot.width, vertical_slot.width, direction),
                    height = ugui.internal.lerp(horizontal_slot.height, vertical_slot.height, direction),
                }
            end

            return slots
        end,
    },

}

---Gets the appropriate layout strategy for the specified node.
---@param node SceneNode
---@return LayoutStrategy
function ugui.internal.get_strategy(node)
    if node.control.layout and node.control.layout == 'stack' then
        return ugui.internal.layout_strategies.stack
    end
    return ugui.internal.layout_strategies.biggest
end

---Measures the specified node and saves its size.
---@param node SceneNode
---@param available_size Vector2
---@return Vector2
function ugui.internal.measure(node, available_size)
    -- We cache the natural sizes per-frame because they can be REALLY expensive to compute and we'd churn through these up to like 5 times depending on depth.
    if ugui.internal.control_data[node.control.uid].natural_size then
        return ugui.internal.control_data[node.control.uid].natural_size
    end

    local registry_entry = ugui.registry[node.type]

    local size
    ugui.internal.with_styler_mixin(node.control, function()
        -- Always run the default measure too since even controls with custom measure implementations may have children (user measure implementations arent required to measure children)
        size = ugui.internal.get_strategy(node).measure(node, available_size)
        if registry_entry.measure then
            size = registry_entry.measure(node, available_size)
        end
    end)

    local padding = node.control.padding and ugui.internal.resolve_unit2(node.control.padding, {x = 0, y = 0}, {x = 0, y = 0}) or {x = 0, y = 0}

    size.x = size.x + padding.x * 2
    size.y = size.y + padding.y * 2

    ugui.internal.control_data[node.control.uid].natural_size = size

    return size
end

---Arranges the node's children.
---@param node SceneNode
---@param slot Rectangle
function ugui.internal.arrange(node, slot)
    ugui.internal.control_data[node.control.uid].slot = slot

    local slots = ugui.internal.get_strategy(node).arrange(node, slot)

    for i = 1, #slots, 1 do
        ugui.internal.arrange(node.children[i], slots[i])
    end
end

function ugui.internal.layout()
    ugui.internal.foreach_node_from_root(function(node)
        ugui.internal.control_data[node.control.uid].natural_size = nil
        ugui.internal.control_data[node.control.uid].render_rect = nil
    end)

    ugui.internal.measure(ugui.internal.root, {x = ugui.internal.environment.window_size.x, y = ugui.internal.environment.window_size.y})
    ugui.internal.arrange(ugui.internal.root, {x = 0, y = 0, width = ugui.internal.environment.window_size.x, height = ugui.internal.environment.window_size.y})

    ugui.internal.foreach_node_from_root(function(node)
        local control = node.control
        local slot = ugui.internal.control_data[node.control.uid].slot
        if control.margin then
            local pos = ugui.internal.resolve_unit2(control.margin, {x = 0, y = 0}, {x = slot.width, y = slot.height})
            control.rectangle.x = pos.x
            control.rectangle.y = pos.y
        end
        if control.size then
            local natural_size = ugui.internal.control_data[node.control.uid].natural_size
            local size = ugui.internal.resolve_unit2(control.size, natural_size, {x = slot.width, y = slot.height})
            control.rectangle.width = size.x
            control.rectangle.height = size.y
        end
    end)

    -- Arrange again because sizes have been computed.
    ugui.internal.arrange(ugui.internal.root, {x = 0, y = 0, width = ugui.internal.environment.window_size.x, height = ugui.internal.environment.window_size.y})

    local function compute_render_rect(node, parent_rect)
        local data = ugui.internal.control_data[node.control.uid]

        if data.render_rect then
            return
        end

        local slot = data.slot

        local min_x<const> = slot.x
        local max_x<const> = min_x + slot.width - node.control.rectangle.width

        local min_y<const> = slot.y
        local max_y<const> = min_y + slot.height - node.control.rectangle.height

        local align = ugui.internal.resolve_alignment2(node.control.align)
        local x_offset<const> = ugui.internal.remap(align.x, 0, 1, min_x, max_x)
        local y_offset<const> = ugui.internal.remap(align.y, 0, 1, min_y, max_y)

        local x<const> = node.control.rectangle.x + parent_rect.x + x_offset
        local y<const> = node.control.rectangle.y + parent_rect.y + y_offset

        data.render_rect = {x = x, y = y, width = node.control.rectangle.width, height = node.control.rectangle.height}

        for _, child in pairs(node.children) do
            compute_render_rect(child, data.render_rect)
        end
    end

    compute_render_rect(ugui.internal.root, {x = 0, y = 0, width = ugui.internal.environment.window_size.x, height = ugui.internal.environment.window_size.y})
end
