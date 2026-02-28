--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@type ControlRegistryEntry
ugui.registry.carrousel_button = {
    ---@param control CarrouselButton
    validate = function(control)
        ugui.internal.assert(type(control.items) == 'table', 'expected items to be string[]')
        ugui.internal.assert(type(control.selected_index) == 'number', 'expected selected_index to be number')
    end,
    ---@param control CarrouselButton
    ---@return ControlReturnValue
    logic = function(control, data)
        data.selected_index = control.selected_index

        if ugui.internal.clicked_control == control.uid then
            local relative_x = ugui.internal.environment.mouse_position.x - control.rectangle.x
            if relative_x > control.rectangle.width / 2 then
                data.selected_index = data.selected_index + 1
                if data.selected_index > #control.items then
                    data.selected_index = 1
                end
            else
                data.selected_index = data.selected_index - 1
                if data.selected_index < 1 then
                    data.selected_index = #control.items
                end
            end
        end

        local selected_index = (control.items and ugui.internal.clamp(data.selected_index, 1, #control.items) or nil)

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
            selected_index ~= control.selected_index)

        return {
            primary = selected_index,
            meta = {
                signal_change = data.signal_change,
            },
        }
    end,
    ---@param control CarrouselButton
    draw = function(control)
        ugui.standard_styler.draw_carrousel_button(control)
    end,
}

---Places a CarrouselButton.
---@param control CarrouselButton The control table.
---@return integer, Meta # The new selected index.
ugui.carrousel_button = function(control)
    local result = ugui.control(control, 'carrousel_button')
    return result.primary, result.meta
end
