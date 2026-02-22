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

    if not ugui.internal.environment then
        ugui.internal.environment = environment
    end
    if not environment.window_size then
        -- Assume unbounded window size if user is too lazy to provide one
        environment.window_size = { x = math.maxinteger, y = math.maxinteger }
    end
    ugui.internal.previous_environment = ugui.internal.deep_clone(ugui.internal
        .environment)
    ugui.internal.environment = ugui.internal.deep_clone(environment)

    if ugui.internal.is_mouse_just_down() then
        ugui.internal.mouse_down_position = ugui.internal.environment.mouse_position
    end
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
    for i = 1, #ugui.internal.scene, 1 do
        local control = ugui.internal.scene[i].control
        local type = ugui.internal.scene[i].type

        local entry = ugui.registry[type]

        local revert_styler_mixin = ugui.internal.apply_styler_mixin(control)

        entry.draw(control)

        revert_styler_mixin()

        if ugui.DEBUG then
            if ugui.internal.keyboard_captured_control == control.uid then
                BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 4), '#000000', 2)
            end
            if ugui.internal.mouse_captured_control == control.uid then
                BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 8), '#FF0000', 2)
            end
        end
    end

    ugui.internal.tooltip()

    -- Store UIDs that were present in this frame
    ugui.internal.previous_uids = {}
    for i = 1, #ugui.internal.scene, 1 do
        local control = ugui.internal.scene[i].control
        ugui.internal.previous_uids[control.uid] = true
    end

    ugui.internal.scene = {}
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

    ---@type ControlRegistryEntry?
    local registry_entry = ugui.registry[type]

    if registry_entry == nil then
        error(string.format("Unknown control type '%s'", type))
    end

    local return_value

    local revert_styler_mixin = ugui.internal.apply_styler_mixin(control)

    -- If the control has only just been added, we run its setup.
    if ugui.internal.control_data[control.uid] == nil then
        init_control_data(control.uid)

        if registry_entry.setup then
            registry_entry.setup(control, ugui.internal.control_data[control.uid])
        end

        -- Run logic once to stabilize the return value for the first state
        return_value = registry_entry.logic(control, ugui.internal.control_data[control.uid])
    end

    -- Check for UID duplicates
    for i = 1, #ugui.internal.scene, 1 do
        local uid = ugui.internal.scene[i].control.uid
        if control.uid == uid then
            error(string.format(
                'Attempted to show a control with uid %d, which is already in use! Note that some controls reserve more than one uid slot after them.',
                control.uid))
        end
    end

    -- Check that any existing control with the same UID matches this control's type
    local stored_control_type = ugui.internal.control_types[control.uid]
    if stored_control_type ~= nil and stored_control_type ~= type then
        error(string.format('Attempted to reuse UID %d of %s for %s.', control.uid,
            ugui.internal.control_types[control.uid], type))
    end

    registry_entry.validate(control)

    -- Run logic pass immediately for the current frame so callers receive an up-to-date value instead of the previous frame's result.
    return_value = registry_entry.logic(control, ugui.internal.control_data[control.uid])

    ugui.internal.scene[#ugui.internal.scene + 1] = {
        control = control,
        type = type,
    }
    ugui.internal.control_types[control.uid] = type

    revert_styler_mixin()

    return return_value
end
