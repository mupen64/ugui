--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class ControlRegistryEntry
---@field public validate fun(control: Control)? Verifies that a control instance matches the desired type.
---@field public setup fun(control: Control, data: any)? Sets up the initial control data to be used in `logic` and `draw`.
---@field public added fun(control: Control, data: any)? Notifies about a control being added to a scene.
---@field public logic (fun(control: Control, data: any): ControlReturnValue)? Executes control logic.
---@field public draw (fun(control: Control))? Draws the control.
---@field public hittestable (fun(control: Control): boolean)? A function returning whether a control instance of this type should participate in hit-testing. If `nil`, the instance-level `hittestable` field is used. If both are `nil`, the control is hittestable.
---Represents an entry in the control registry.

---@class Control
---@field public hittestable boolean? Whether this control instance participates in hit-testing. Overrides the registry-level `hittestable` function if specified. Defaults to `true` if neither this nor the registry function is set.

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
    ugui.panel({
        uid = 0,
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

    -- 2. Input processing pass
    ugui.internal.do_input_processing()

    -- 3. Event dispatching pass
    ugui.internal.dispatch_events()

    -- 4. Rendering pass
    ugui.internal.foreach_node_from_root(function(node)
        local control = node.control
        local type = node.type

        local entry = ugui.registry[type]

        if entry.draw then
            local revert_styler_mixin = ugui.internal.apply_styler_mixin(control)
            entry.draw(control)
            revert_styler_mixin()
        end

        if ugui.DEBUG then
            if ugui.internal.keyboard_captured_control == control.uid then
                BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 4), '#000000', 2)
            end
            if ugui.internal.mouse_captured_control == control.uid then
                BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 8), '#FF0000', 2)
            end
        end
    end)

    -- ugui.internal.tooltip()

    -- Store UIDs that were present in this frame
    ugui.internal.previous_uids = {}
    for i = 1, #ugui.internal.root, 1 do
        local control = ugui.internal.root[i].control
        ugui.internal.previous_uids[control.uid] = true
    end

    ugui.internal.last_control_rectangle = nil
    ugui.internal.frame_in_progress = false
end

---Places a Control of the specified type.
---@param control Control The control.
---@param type ControlType | "" The control's type. If the type is `""`, no control will be placed, but the control data entry will be initialized.
---@return ControlReturnValue # The control's return value, or `nil` if the type is `""`.
ugui.control = function(control, type)
    local function init_control_data(uid)
        ugui.internal.control_data[uid] = {
            signal_change = ugui.signal_change_states.none,
        }
    end

    if type == '' then
        init_control_data(control.uid)
        return nil
    end

    ---@cast type ControlType

    local registry_entry = ugui.registry[type]
    ugui.internal.assert(registry_entry ~= nil, string.format("Unknown control type '%s'", type))

    local return_value = {primary = nil, meta = {signal_change = ugui.signal_change_states.none}}
    local has_root<const> = ugui.internal.root ~= nil

    local revert_styler_mixin = ugui.internal.apply_styler_mixin(control)

    -- If the control has only just been added, we run its setup.
    if ugui.internal.control_data[control.uid] == nil then
        init_control_data(control.uid)

        if registry_entry.setup then
            registry_entry.setup(control, ugui.internal.control_data[control.uid])
        end

        -- Run logic once to stabilize the return value for the first state.
        if registry_entry.logic then
            return_value = registry_entry.logic(control, ugui.internal.control_data[control.uid])
        end
    end

    if has_root then
        -- Check for UID duplicates.
        ugui.internal.foreach_node_from_root(function(node)
            local uid = node.control.uid
            ugui.internal.assert(control.uid ~= uid, string.format('Attempted to show a control with uid %d, which is already in use! Note that some controls reserve more than one uid slot after them.', uid))
        end)

        -- Check for cross-frame control type clobbering (e.g. button becoming a textbox)
        local stored_control_type = ugui.internal.control_types[control.uid]
        ugui.internal.assert(stored_control_type == nil or stored_control_type == type,
            string.format('Attempted to reuse UID %d of %s for %s.', control.uid, stored_control_type, type))
    else
        ugui.internal.root = {
            control = control,
            type = type,
            children = {},
        }
    end

    if registry_entry.validate then
        registry_entry.validate(control)
    end

    -- Run logic pass immediately for the current frame so callers receive an up-to-date value instead of the previous frame's result.
    if registry_entry.logic then
        return_value = registry_entry.logic(control, ugui.internal.control_data[control.uid])
    end

    if has_root then
        ugui.internal.root.children[#ugui.internal.root.children + 1] = {
            control = control,
            type = type,
            children = {},
        }
    end
    ugui.internal.control_types[control.uid] = type

    revert_styler_mixin()

    return return_value
end
