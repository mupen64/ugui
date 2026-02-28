--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---Places a TabControl.
---@param control TabControl The control table.
---@return TabControlResult, Meta # The result.
ugui.tabcontrol = function(control)
    local _ = ugui.control(control, '')
    local data = ugui.internal.control_data[control.uid]

    if data.scroll_x == nil then
        data.scroll_x = 0
    end

    if data.scroll_y == nil then
        data.scroll_y = 0
    end

    if ugui.standard_styler.params.tabcontrol.draw_frame then
        local clone = ugui.internal.deep_clone(control)
        clone.items = {}
        ugui.standard_styler.draw_list(clone, clone.rectangle)
    end

    local x = 0
    local y = 0
    local selected_index = control.selected_index

    local num_items = control.items and #control.items or 0
    for i = 1, num_items, 1 do
        local item = control.items[i]

        local width = ugui.standard_styler.compute_rich_text(item, control.plaintext).size.x + 10

        -- if it would overflow, we wrap onto a new line
        if x + width > control.rectangle.width then
            x = 0
            y = y + ugui.standard_styler.params.tabcontrol.rail_size + ugui.standard_styler.params.tabcontrol.gap_y
        end

        local _, meta = ugui.toggle_button({
            uid = control.uid + i,
            is_enabled = control.is_enabled,
            rectangle = {
                x = control.rectangle.x + x,
                y = control.rectangle.y + y,
                width = width,
                height = ugui.standard_styler.params.tabcontrol.rail_size,
            },
            text = control.items[i],
            is_checked = selected_index == i,
        })

        if meta.signal_change == ugui.signal_change_states.started then
            selected_index = i
        end

        x = x + width + ugui.standard_styler.params.tabcontrol.gap_x
    end

    data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
        control.selected_index ~= selected_index)

    return {
        selected_index = selected_index,
        rectangle = {
            x = control.rectangle.x,
            y = control.rectangle.y + ugui.standard_styler.params.tabcontrol.rail_size + y,
            width = control.rectangle.width,
            height = control.rectangle.height - y - ugui.standard_styler.params.tabcontrol.rail_size,
        },
    }, { signal_change = data.signal_change }
end
