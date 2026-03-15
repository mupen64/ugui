--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Label : Control
---@field public text RichText The text.
---@field public color Color? The color of the text.
---@field public font_size number? The font size of the text. If `nil`, the default font size is used.
---@field public font_name string? The font family of the text. If `nil`, the default font family is used.
---@field public align_x Alignment? The text's horizontal alignment inside the control rectangle. If `nil`, `alignment.center` is assumed.
---@field public align_y Alignment? The text's vertical alignment inside the control rectangle. If `nil`, `alignment.center` is assumed.
---A label that contains text.

---@type ControlRegistryEntry
ugui.registry.label = {
    ---@param control Label
    validate = function(control)
        ugui.internal.assert(type(control.text) == 'string', 'expected text to be string')
    end,
    ---@param control Label
    ---@return ControlReturnValue
    logic = function(control, data)
        return {
            primary = nil,
            meta = {
                signal_change = ugui.signal_change_states.none,
            },
        }
    end,
    ---@param control Label
    draw = function(control)
        local visual_state = ugui.get_visual_state(control)
        ugui.standard_styler.draw_rich_text(control.rectangle, control.align_x, control.align_y, control.text, control.color, visual_state, control.plaintext, control.font_name, control.font_size)
    end,
}

---Places a Label.
---@param control Label The control table.
---@return integer, Meta # Nothing.
ugui.label = function(control)
    local result = ugui.control(control, 'label')
    return result.primary, result.meta
end
