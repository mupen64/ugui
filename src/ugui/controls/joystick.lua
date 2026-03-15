--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Joystick : Control
---@field public position Vector2 The joystick's position with the range 0-128 on both axes.
---@field public mag number? The joystick's magnitude circle radius with the range `0-128`. If nil, no magnitude circle will be drawn.
---@field public x_snap integer? The snap distance to 0 on the X axis. If nil, no snap will be applied.
---@field public y_snap integer? The snap distance to 0 on the Y axis. If nil, no snap will be applied.
---A joystick which can be interacted with.

---@type ControlRegistryEntry
ugui.registry.joystick = {
    ---@param control Joystick
    validate = function(control)
        ugui.internal.assert(type(control.position) == 'table', 'expected position to be table')
        ugui.internal.assert(type(control.position.x) == 'number', 'expected position.x to be number')
        ugui.internal.assert(type(control.position.y) == 'number', 'expected position.y to be number')
        ugui.internal.assert(type(control.mag) == 'nil' or type(control.mag) == 'number',
            'expected mag to be nil or number')
        ugui.internal.assert(type(control.x_snap) == 'nil' or type(control.x_snap) == 'number',
            'expected x_snap to be nil or number')
        ugui.internal.assert(type(control.y_snap) == 'nil' or type(control.y_snap) == 'number',
            'expected y_snap to be nil or number')
    end,
    setup = function(control, data)
        if data.signal_change == nil then
            data.signal_change = ugui.signal_change_states.none
        end
    end,
    ---@param control Joystick
    ---@return ControlReturnValue
    logic = function(control, data)
        data.position = ugui.internal.deep_clone(control.position)

        if ugui.internal.mouse_captured_control == control.uid then
            data.position.x = ugui.internal.clamp(
                ugui.internal.remap(ugui.internal.environment.mouse_position.x - control.rectangle.x, 0,
                    control.rectangle.width, -128, 128), -128, 128)
            data.position.y = ugui.internal.clamp(
                ugui.internal.remap(ugui.internal.environment.mouse_position.y - control.rectangle.y, 0,
                    control.rectangle.height, -128, 128), -128, 128)
            if control.x_snap and data.position.x > -control.x_snap and data.position.x < control.x_snap then
                data.position.x = 0
            end
            if control.y_snap and data.position.y > -control.y_snap and data.position.y < control.y_snap then
                data.position.y = 0
            end
        end

        data.signal_change = ugui.internal.process_signal_changes(data.signal_change,
            control.position.x ~= data.position.x or control.position.y ~= data.position.y)

        return {
            primary = data.position,
            meta = { signal_change = data.signal_change },
        }
    end,
    ---@param control Joystick
    draw = function(control)
        ugui.standard_styler.draw_joystick(control)
    end,
}

---Places a Joystick.
---@param control Joystick The control table.
---@return Vector2, Meta
ugui.joystick = function(control)
    local result = ugui.control(control, 'joystick')
    return result.primary, result.meta
end
