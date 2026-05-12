--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class ControlRegistryEntry
---@field public place (fun(control: Control, fn: fun()?): ControlReturnValue)? Places the control in the scene. Useful for templated controls. If `nil`, the control will be placed directly.
---@field public validate fun(control: Control)? Verifies that a control instance matches the desired type.
---@field public setup fun(control: Control, data: any)? Sets up the initial control data to be used in `logic` and `draw`.
---@field public logic (fun(control: Control, data: any): ControlReturnValue)? Executes control logic.
---@field public draw (fun(control: Control))? Draws the control.
---@field public measure (fun(node: SceneNode, available_size: Vector2): Vector2)? Measures the control's natural size.
---@field public hittestable (fun(control: Control): boolean)? A function returning whether a control instance of this type should participate in hit-testing. If `nil`, the instance-level `hittestable` field is used. If both are `nil`, the control is hittestable.
---Represents an entry in the control registry.

---@alias ContentSlotCallback fun()
---A callback invoked after a control has been placed.
---Controls placed inside this callback will be parented to whatever the control decides is appropriate (though it usually is just the control itself).

---@alias SmartUnit
---| "0"
---| "auto"
---| string
---
---A size unit specification that can be:
---
---    `"auto"` - natural size
---    `"{}px"` - absolute pixels (e.g. `"100px"`)
---    `"{}%"` - percentage of parent size (e.g. `"50%"`)
---
---Zero literals are treated as `0px` (e.g. `0` => `0px`)
---
---Basic arithmetic operations are also supported: `+`, `-`, `*`, `/`.
---
---    `100px-3%`
---    `auto*10px`
---
---Constraints can also be applied:
---
---    `min(auto,5px)`
---    `max(auto,5px)`
---    `clamp(auto,5px,10px)`


---@alias SmartUnit2
---| "0"
---| "auto"
---| "0 0"
---| "auto auto"
---| string
---
---A two-dimensional unit that is composed of two SmartUnits.
---
---If one component is omitted, it's assumed to be equal to the other component.
---
---    `100px 100px`
---    `100px` (expands to `100px 100px`)
---    `auto 50%`

---@alias SmartAlignment
---| "0"
---| "0%"
---| "0.5"
---| "50%"
---| "1"
---| "100%"
---| "left"
---| "right"
---| "top"
---| "bottom"
---| "center"
---| string
---An alignment unit that specifies how a control is aligned within its parent.
---
---    `0`, `0%` - start of parent
---    `0.5`, `50%` - center of parent
---    `1`, `100%` - end of parent

---@alias SmartAlignment2
---| "0"
---| "0 0"
---| "0%"
---| "0% 0%"
---| "0.5"
---| "0.5 0.5"
---| "50%"
---| "50% 50%"
---| "1"
---| "1 1"
---| "100%"
---| "100% 100%"
---| "left"
---| "left left"
---| "right"
---| "right right"
---| "top"
---| "top top"
---| "bottom"
---| "bottom bottom"
---| "center"
---| "center center"
---| string
---
---A two-dimensional alignment unit that is composed of two SmartAlignments.
---
---If one component is omitted, it's assumed to be equal to the other component.
---
---    `0 0` - top-left corner
---    `0` - top-left corner
---    `50%`, `center`, `center center` - center
---    `left`, `left left` - left edge
---    `right`, `right right` - right edge
---    `top`, `top top` - top edge
---    `bottom`, `bottom bottom` - bottom edge

---@alias UID number
---Unique identifier for a control. Must be unique within a frame.

---@alias RichText string
---Text which can contain other inline elements, such as icons.
---
---Examples:
---
---    [icon:arrow_left] Go Back
---    Move up [icon:arrow_up]
---    Down [icon:arrow_down:#FFFF00]
---    [icon:arrow_right:textbox.selection] Go Forward
---    Hello World!

---@alias RichTextSegment { type: ["text"|"icon"], value: string, color: string? }
---Represents a computed segment from a rich text string.

---@class ToolTip
---@field public text RichText The tooltip's text.
---A tooltip, which can be used to show additional information about a control.

---@class Meta
---@field public signal_change SignalChangeState The change state of the control's primary signal.
---Additional information about a placed control.

---@alias ControlReturnValue { primary: any, meta: Meta }

---@alias ControlType "panel" | "label" | "button" | "toggle_button" | "carrousel_button" | "textbox" | "joystick" | "trackbar" | "listbox" | "scrollbar" | "combobox" | "menu" | "numberbox"

---@enum VisualState
-- The possible states of a control, which are used by the styler for drawing.
ugui.visual_states = {
    --- The control doesn't accept user interactions.
    disabled = 0,
    --- The control isn't being interacted with.
    normal = 1,
    --- The mouse is over the control.
    hovered = 2,
    --- The control is currently capturing inputs.
    active = 3,
}

---@enum SignalChangeState
--- The change in the primary signal ("return value") of a control.
ugui.signal_change_states = {
    --- The signal isn't changing.
    none = 0,
    --- The signal has just started changing.
    started = 1,
    --- The signal is currently changing.
    ongoing = 2,
    --- The signal has just stopped changing.
    ended = 3,
}

---@type { [string]: ControlRegistryEntry }
ugui.registry = {}

---Gets the basic visual state of a control.
---@param control Control The control.
---@return VisualState # The control's visual state.
ugui.get_visual_state = function(control)
    if control.is_enabled == false then
        return ugui.visual_states.disabled
    end

    if ugui.internal.clicked_control == control.uid then
        return ugui.visual_states.active
    end

    if ugui.internal.mouse_captured_control == control.uid then
        return ugui.visual_states.active
    end

    if ugui.internal.hovered_control == control.uid then
        return ugui.visual_states.hovered
    end

    return ugui.visual_states.normal
end

---Begins a new frame.
---@param environment Environment The environment for the current frame.
ugui.begin_frame = function(environment)
    if ugui.internal.frame_in_progress then
        error(
            'Tried to call begin_frame() while a frame is already in progress. End the previous frame with end_frame() before starting a new one.')
    end

    ugui.internal.frame_in_progress = true
    local current_time = os.clock()
    ugui.internal.delta_time = current_time - ugui.internal.last_frame_time
    ugui.internal.last_frame_time = current_time

    if not ugui.internal.environment then
        ugui.internal.environment = environment
    end

    if not environment.window_size then
        -- Assume unbounded window size if user is too lazy to provide one
        environment.window_size = {x = math.maxinteger, y = math.maxinteger}
    end

    -- Replace paste operations with synthetic type events.
    local clipboard_text
    for i, e in ipairs(environment.key_events) do
        if e.pressed and e.keycode == ugui.keycodes.VK_V and e.ctrl then
            if not clipboard_text then
                clipboard_text = ugui.STATIC_ENV.clipboard.get()
            end

            if clipboard_text then
                environment.key_events[i] = {
                    ctrl = false,
                    shift = false,
                    alt = false,
                    meta = false,
                    text = clipboard_text,
                    ['repeat'] = false,
                }
            end
        end
    end

    ugui.internal.previous_environment = ugui.internal.deep_clone(ugui.internal.environment)
    ugui.internal.environment = ugui.internal.deep_clone(environment)

    if ugui.internal.is_mouse_just_down() then
        ugui.internal.mouse_down_position = ugui.internal.environment.mouse_position
    end

    ugui.internal.root = nil
    ugui.internal.current_parent = nil
    ugui.panel({
        uid = math.mininteger,
        rectangle = {x = 0, y = 0, width = ugui.internal.environment.window_size.x, height = ugui.internal.environment.window_size.y},
    })
end

--- Ends the current frame.
ugui.end_frame = function()
    if not ugui.internal.frame_in_progress then
        error(
            "Tried to call end_frame() while a frame wasn't already in progress. Start a frame with begin_frame() before ending an in-progress one.")
    end

    -- 1. Z-Sorting pass
    ugui.internal.sort_scene()

    -- 2. Layout pass
    ugui.internal.layout()

    -- 3. Input processing pass
    ugui.internal.do_input_processing()

    -- 4. Event dispatching pass
    ugui.internal.dispatch_events()

    -- 5. Rendering pass
    ugui.internal.render()

    ugui.internal.tooltip()

    if ugui.DEBUG then
        for _, e in pairs(ugui.internal.environment.key_events) do
            if e.pressed and e.keycode == ugui.keycodes.VK_A then
                ugui.internal.print_tree(ugui.internal.root)
            end
        end
    end

    ugui.internal.last_control_rectangle = nil
    ugui.internal.frame_in_progress = false
    ugui.internal.node_by_uid = {}
end

---Places a Control of the specified type.
---@param control Control The control.
---@param type ControlType | "" The control's type. **`""` is deprecated as a value - don't pass it.**
---@param fn ContentSlotCallback? The content slot callback.
---@return ControlReturnValue # The control's return value.
ugui.control = function(control, type, fn)
    local function init_control_data(uid)
        ugui.internal.control_data[uid] = {
            signal_change = ugui.signal_change_states.none,
            natural_size = {x = 0, y = 0},
            render_rect = {x = 0, y = 0, width = 0, height = 0},
        }
    end

    if type == '' then
        init_control_data(control.uid)
        return nil
    end

    local registry_entry = ugui.registry[type]
    ugui.internal.assert(registry_entry ~= nil, string.format("Unknown control type '%s'", type))
    local result
    if registry_entry.place then
        result = registry_entry.place(control, fn)
    else
        result = ugui.internal.place_control(control, type, fn)
    end

    return result
end
