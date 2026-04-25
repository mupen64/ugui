--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Label : Control
---@field public text RichText The text.
---@field public color Color The color of the text.
---@field public font_size number? The font size of the text. If `nil`, the default font size is used.
---@field public font_name string? The font family of the text. If `nil`, the default font family is used.
---@field public align_x Alignment? The text's horizontal alignment inside the control rectangle. If `nil`, `alignment.center` is assumed.
---@field public align_y Alignment? The text's vertical alignment inside the control rectangle. If `nil`, `alignment.center` is assumed.
---@field public selectable boolean? Whether the label's text is selectable. If `true`, the label participates in hit-testing to allow text selection.
---A label that contains text.

---@type ControlRegistryEntry
ugui.registry.label = {
    hittestable = function(control)
        return control.selectable == true
    end,
    ---@param control Label
    validate = function(control)
        ugui.internal.assert(type(control.text) == 'string', 'expected text to be string')
        ugui.internal.assert(type(control.color) == 'table', 'expected color to be table')
        ugui.internal.assert(type(control.font_size) == 'number' or control.font_size == nil, 'expected font_size to be number or nil')
        ugui.internal.assert(type(control.font_name) == 'string' or control.font_name == nil, 'expected font_name to be string or nil')
        ugui.internal.assert(type(control.align_x) == 'number' or control.align_x == nil, 'expected align_x to be number or nil')
        ugui.internal.assert(type(control.align_y) == 'number' or control.align_y == nil, 'expected align_y to be number or nil')
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
---@return nil, Meta # Nothing.
ugui.label = function(control)
    local result = ugui.control(control, 'label')
    return result.primary, result.meta
end
