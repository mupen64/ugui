--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class TabControl : Control
---@field public items RichText[] The tab headers.
---@field public selected_index integer The index of the currently selected tab.
---A tab control, which allows the user to choose from a list of tabs.

---@class TabControlResult
---@field public selected_index integer The index of the selected tab.
---@field public rectangle Rectangle The visual bounds the selected tab can place its contents in.

---Places a TabControl.
---@param control TabControl The control table.
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return TabControlResult, Meta # The result.
ugui.tabcontrol = function(control, fn)
    local button_uid = control.uid + 1

    ugui.control(control, 'panel', function()
        local data = ugui.internal.control_data[control.uid]
        if not data.is_tab_control then
            data.is_tab_control = true
            data.rail_render_rect = {x = 0, y = 0, width = 0, height = 0}
            data.selected_index = 1
        end

        for i = 1, #control.items do
            local _, meta = ugui.toggle_button({
                uid = button_uid,
                size = string.format('auto %fpx', ugui.standard_styler.params.tabcontrol.rail_size),
                text = control.items[i],
                is_checked = data.selected_index == i,
            })

            if meta.signal_change == ugui.signal_change_states.started then
                data.selected_index = i
            end

            button_uid = button_uid + 2
        end
    end)

    local data = ugui.internal.control_data[control.uid]

    if ugui.standard_styler.params.tabcontrol.draw_frame then
        local clone = ugui.internal.deep_clone(control)
        clone.items = {}
        ugui.standard_styler.draw_list(clone, clone.rectangle)
    end

    data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
        control.selected_index ~= data.selected_index)

    return {
        selected_index = data.selected_index,
        rectangle = data.rail_render_rect,
    }, {signal_change = data.signal_change}
end
