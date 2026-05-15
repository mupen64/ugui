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
            local natural_size = ugui.internal.control_data[node.control.uid].natural_size
            local slots = {}
            for _, child in pairs(node.children) do
                slots[#slots + 1] = {x = 0, y = 0, width = natural_size.x, height = natural_size.y}
            end
            return slots
        end,
    },
    stack = {
        measure = function(node, available_size)
            local direction = node.control.direction or 0
            local wrap = node.control.wrap or false

            local inner_available = available_size
            if node.control.size then
                inner_available = ugui.internal.resolve_unit2(node.control.size, available_size, available_size)
            end

            local function measure_horizontal()
                local cursor_x = 0
                local cursor_y = 0
                local row_height = 0
                local total = {x = 0, y = 0}

                for _, child in pairs(node.children) do
                    local size = ugui.internal.measure(child, inner_available)
                    local margin = ugui.internal.control_data[child.control.uid].computed_margin
                    local child_w = size.x + margin.x
                    local child_h = size.y + margin.y

                    if wrap and cursor_x > 0 and cursor_x + child_w > inner_available.x then
                        total.x = math.max(total.x, cursor_x)
                        cursor_y = cursor_y + row_height
                        cursor_x = 0
                        row_height = 0
                    end

                    cursor_x = cursor_x + child_w
                    row_height = math.max(row_height, child_h)
                end

                total.x = math.max(total.x, cursor_x)
                total.y = cursor_y + row_height
                return total
            end

            local function measure_vertical()
                local cursor_x = 0
                local cursor_y = 0
                local col_width = 0
                local total = {x = 0, y = 0}

                for _, child in pairs(node.children) do
                    local size = ugui.internal.measure(child, inner_available)
                    local margin = ugui.internal.control_data[child.control.uid].computed_margin
                    local child_w = size.x + margin.x
                    local child_h = size.y + margin.y

                    if wrap and cursor_y > 0 and cursor_y + child_h > inner_available.y then
                        total.y = math.max(total.y, cursor_y)
                        cursor_x = cursor_x + col_width
                        cursor_y = 0
                        col_width = 0
                    end

                    cursor_y = cursor_y + child_h
                    col_width = math.max(col_width, child_w)
                end

                total.y = math.max(total.y, cursor_y)
                total.x = cursor_x + col_width
                return total
            end

            local horizontal_size = measure_horizontal()
            local vertical_size = measure_vertical()

            return {
                x = ugui.internal.lerp(horizontal_size.x, vertical_size.x, direction),
                y = ugui.internal.lerp(horizontal_size.y, vertical_size.y, direction),
            }
        end,
        arrange = function(node, slot)
            local natural_size = ugui.internal.control_data[node.control.uid].natural_size

            local direction<const> = node.control.direction or 0
            local wrap<const> = node.control.wrap or false

            local function arrange_horizontal()
                local accumulator = {x = 0, y = 0}
                local row_height = 0
                local slots = {}

                for _, child in pairs(node.children) do
                    local child_data = ugui.internal.control_data[child.control.uid]
                    local child_size = {
                        x = child_data.natural_size.x + child_data.computed_margin.x,
                        y = child_data.natural_size.y + child_data.computed_margin.y,
                    }

                    if wrap and accumulator.x + child_size.x > natural_size.x then
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
                    local child_data = ugui.internal.control_data[child.control.uid]
                    local child_size = {
                        x = child_data.natural_size.x + child_data.computed_margin.x,
                        y = child_data.natural_size.y + child_data.computed_margin.y,
                    }

                    if wrap and accumulator.y + child_size.y > natural_size.y then
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
    local data = ugui.internal.control_data[node.control.uid]

    -- We cache the natural sizes per-frame because they can be REALLY expensive to compute and we'd churn through these up to like 5 times depending on depth.
    if data.natural_size then
        return data.natural_size
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

    local initial_natural_size = {x = size.x, y = size.y}

    if node.control.size then
        -- auto = natural_size ; max = available_size
        size = ugui.internal.resolve_unit2(node.control.size, initial_natural_size, available_size)
    end

    if node.control.margin then
        -- auto = 0 ; max = natural_size
        data.computed_margin = ugui.internal.resolve_unit2(node.control.margin, {x = 0, y = 0}, initial_natural_size)
    else
        if node.control.rectangle then
            data.computed_margin = {x = node.control.rectangle.x, y = node.control.rectangle.y}
        end
    end

    if not node.control.size and node.control.rectangle then
        if node.control.rectangle.width then
            size.x = node.control.rectangle.width
        end
        if node.control.rectangle.height then
            size.y = node.control.rectangle.height
        end
    end

    data.computed_padding = node.control.padding and ugui.internal.resolve_unit2(node.control.padding, {x = 0, y = 0}, {x = 0, y = 0}) or {x = 0, y = 0}

    size.x = size.x + data.computed_padding.x * 2
    size.y = size.y + data.computed_padding.y * 2

    data.natural_size = size

    return ugui.internal.deep_clone(size)
end

---Arranges the node's children.
---@param node SceneNode
---@param slot Rectangle
function ugui.internal.arrange(node, slot)
    local data = ugui.internal.control_data[node.control.uid]
    data.slot = slot

    local slots = ugui.internal.get_strategy(node).arrange(node, slot)

    for i = 1, #slots, 1 do
        slots[i].x = slots[i].x + data.computed_padding.x
        slots[i].y = slots[i].y + data.computed_padding.y

        ugui.internal.arrange(node.children[i], slots[i])
    end
end

function ugui.internal.layout()
    ugui.internal.foreach_node_from_root(function(node)
        local data = ugui.internal.control_data[node.control.uid]

        data.natural_size = nil
        data.render_rect = nil
        data.computed_margin = nil
    end)

    ugui.internal.measure(ugui.internal.root,
        {x = ugui.internal.environment.window_size.x, y = ugui.internal.environment.window_size.y})

    ugui.internal.arrange(ugui.internal.root, {x = 0, y = 0, width = ugui.internal.environment.window_size.x, height = ugui.internal.environment.window_size.y})

    local function compute_render_rect(node, parent_render_rect)
        local data = ugui.internal.control_data[node.control.uid]

        if data.render_rect then
            return
        end

        local margin = data.computed_margin
        local natural_size = data.natural_size
        local align = ugui.internal.resolve_alignment2(node.control.align)
        local slot = data.slot

        local max_x<const> = slot.width - natural_size.x
        local max_y<const> = slot.height - natural_size.y
        local x_offset<const> = ugui.internal.remap(align.x, 0, 1, 0, max_x)
        local y_offset<const> = ugui.internal.remap(align.y, 0, 1, 0, max_y)

        local x<const> = parent_render_rect.x + slot.x + x_offset + margin.x
        local y<const> = parent_render_rect.y + slot.y + y_offset + margin.y

        data.render_rect = {x = x, y = y, width = natural_size.x, height = natural_size.y}

        for _, child in pairs(node.children) do
            compute_render_rect(child, data.render_rect)
        end
    end

    compute_render_rect(ugui.internal.root, {x = 0, y = 0, width = ugui.internal.environment.window_size.x, height = ugui.internal.environment.window_size.y})
end
