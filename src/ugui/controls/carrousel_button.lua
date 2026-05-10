--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class CarrouselButton : Control
---@field public items string[] The items contained in the carrousel button.
---@field public selected_index integer The index of the currently selected item into the items array.
---A button which can be toggled on and off.
---TODO: Make wraparound optional

---@type ControlRegistryEntry
ugui.registry.carrousel_button = {
    ---@param control CarrouselButton
    place = function(control, fn)
        local label_1_uid<const> = control.uid + 1
        local label_2_uid<const> = control.uid + 2
        local label_3_uid<const> = control.uid + 3

        return ugui.internal.place_control(control, 'carrousel_button', function()
            local visual_state = ugui.get_visual_state(control)
            local text = control.selected_index and control.items[control.selected_index] or ''

            ugui.label({
                uid = label_1_uid,
                text = '[icon:arrow_left]',
                margin = string.format('%dpx 0', ugui.standard_styler.params.textbox.padding.x * 2),
                align = '0% 50%',
                color = ugui.standard_styler.params.button.text[visual_state],
            })
            ugui.label({
                uid = label_2_uid,
                text = text,
                align = '50%',
                color = ugui.standard_styler.params.button.text[visual_state],
            })
            ugui.label({
                uid = label_3_uid,
                text = '[icon:arrow_right]',
                margin = string.format('-%dpx 0', ugui.standard_styler.params.textbox.padding.x * 2),
                align = '100% 50%',
                color = ugui.standard_styler.params.button.text[visual_state],
            })
            if fn then
                fn()
            end
        end)
    end,
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
            local relative_x = ugui.internal.environment.mouse_position.x - data.render_rect.x
            if relative_x > data.render_rect.width / 2 then
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
---@param fn fun()? The function to immediately invoke upon placing the control. In the function's context, any placed controls will be parented to this control.
---@return integer, Meta # The new selected index.
ugui.carrousel_button = function(control, fn)
    local result = ugui.control(control, 'carrousel_button', fn)
    return result.primary, result.meta
end
