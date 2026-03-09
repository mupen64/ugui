--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

ugui.internal = {
    ---@type SceneEntry[]
    scene = {},

    ---@type table<UID, ControlType>
    control_types = {},

    ---@type table<UID, any>
    ---Map of control UIDs to their data.
    control_data = {},

    ---@type { [UID]: boolean }
    ---Dictionary of all UIDs that were present in the previous frame. Used for dispatching events related to control lifecycles via `dispatch_events`.
    previous_uids = {},

    ---@type Environment
    ---The environment for the current frame.
    environment = nil,

    ---@type Environment
    ---The environment for the previous frame.
    previous_environment = nil,

    ---@type Vector2
    -- The position of the mouse the last time the primary button was pressed.
    mouse_down_position = {x = 0, y = 0},

    ---@type UID?
    ---The control that was clicked this frame.
    clicked_control = nil,

    ---@type UID?
    ---The control that is being hovered over.
    hovered_control = nil,

    ---@type UID?
    ---The control that is currently capturing mouse inputs.
    mouse_captured_control = nil,

    ---@type UID?
    ---The control that is currently capturing keyboard inputs. Synonymous to a "focused" control.
    keyboard_captured_control = nil,

    ---@type number
    ---The most recent time at which `hovered_control` changed, as returned by `os.clock`.
    hover_start_time = 0,

    ---Whether a frame is currently in progress.
    frame_in_progress = false,

    ---@type table<string, integer>
    ---Cache of nineslice drawings. Only used after calling `ugui.apply_nineslice`.
    nineslice_draw_cache = {},

    ---Sorts controls stably in the scene by their Z-index.
    sort_scene = function()
        ugui.internal.stable_sort(ugui.internal.scene, function(a, b)
            return (a.control.z_index or 0) < (b.control.z_index or 0)
        end)
    end,

    ---Dispatches events related to controls in the scene.
    dispatch_events = function()
        for _, value in pairs(ugui.internal.scene) do
            local existed_in_previous_frame = false
            for uid, _ in pairs(ugui.internal.previous_uids) do
                if value.control.uid == uid then
                    existed_in_previous_frame = true
                    break
                end
            end

            if not existed_in_previous_frame then
                local registry_entry = ugui.registry[value.type]
                if registry_entry.added then
                    registry_entry.added(value.control, ugui.internal.control_data[value.control.uid])
                end
            end
        end
    end,


    ---@return boolean # Whether LMB was just pressed.
    is_mouse_just_down = function()
        local value = ugui.internal.environment.is_primary_down and
            not ugui.internal.previous_environment.is_primary_down
        return value and true or false
    end,

    ---@return boolean # Whether LMB was just released.
    is_mouse_just_up = function()
        local value = not ugui.internal.environment.is_primary_down and
            ugui.internal.previous_environment.is_primary_down
        return value and true or false
    end,

    ---@return boolean # Whether the mouse wheel was just moved up.
    is_mouse_wheel_up = function()
        return ugui.internal.environment.wheel == 1
    end,

    ---@return boolean # Whether the mouse wheel was just moved down.
    is_mouse_wheel_down = function()
        return ugui.internal.environment.wheel == -1
    end,

    ---Checks whether the specified point lies inside the control's bounds, considering special cases such as the enabled state, hittest-free and offscreen regions.
    ---@param point Vector2 A point.
    ---@param control Control A control.
    ---@return boolean # Whether the point lies inside the control.
    is_point_inside_control = function(point, control)
        if control.is_enabled == false then
            return false
        end
        if not BreitbandGraphics.is_point_inside_rectangle(point, control.rectangle) then
            return false
        end
        if point.x < 0 or point.x > ugui.internal.environment.window_size.x
            or point.y < 0 or point.y > ugui.internal.environment.window_size.y then
            return false
        end
        return true
    end,

    ---Gets the character index for the specified relative x position in a textbox.
    ---Considers font_size and font_name, as provided by the styler.
    ---@param text string The textbox's text.
    ---@param scroll_offset integer The scroll offset.
    ---@param relative_x number The relative x position.
    ---@return integer The character index.
    get_caret_index = function(text, scroll_offset, relative_x)
        local font_size = ugui.standard_styler.params.font_size
        local font_name = ugui.standard_styler.params.font_name

        local scroll_pixel = 0
        if scroll_offset > 1 then
            scroll_pixel = BreitbandGraphics.get_text_size(
                text:sub(1, scroll_offset - 1),
                font_size,
                font_name
            ).width
        end

        local text_x = relative_x + scroll_pixel

        if text_x <= 0 then
            return 1
        end

        local cumulative_width = 0

        for i = 1, #text do
            local char = text:sub(i, i)
            local char_width = BreitbandGraphics.get_text_size(char, font_size, font_name).width

            local midpoint = cumulative_width + char_width * 0.5
            if text_x < midpoint then
                return i
            end

            cumulative_width = cumulative_width + char_width
        end

        return #text + 1
    end,

    ---Applies a control's styler mixin if it has one.
    ---@param control Control The control.
    ---@return function # A function which reverts the styler mixin application when called.
    apply_styler_mixin = function(control)
        if not control.styler_mixin then
            return function() end
        end

        -- If there's a styler mixin, we merge it into the control's rendering params.
        local rollback = ugui.internal.deep_merge(control.styler_mixin, ugui.standard_styler.params)

        -- Revert the styler mixin.
        return function()
            rollback()
        end
    end,

    ---Handles transitions between signal change state.
    ---@param signal_change_state SignalChangeState The control's current signal change state.
    ---@param signal_changing boolean Whether the control's signal is changing.
    process_signal_changes = function(signal_change_state, signal_changing)
        if signal_change_state == ugui.signal_change_states.started then
            return ugui.signal_change_states.ongoing
        end

        if signal_change_state == ugui.signal_change_states.ended then
            return ugui.signal_change_states.none
        end

        if signal_change_state == ugui.signal_change_states.ongoing and signal_changing then
            return ugui.signal_change_states.ongoing
        end

        if signal_change_state == ugui.signal_change_states.ongoing and not signal_changing then
            return ugui.signal_change_states.ended
        end

        if signal_change_state == ugui.signal_change_states.none and signal_changing then
            return ugui.signal_change_states.started
        end

        if signal_change_state == ugui.signal_change_states.none and not signal_changing then
            return ugui.signal_change_states.none
        end

        ugui.internal.assert(false, string.format('Got unexpected signal change state %s and changing %s combination',
            tostring(signal_change_state), tostring(signal_changing)))
    end,

    ---Shows the tooltip for the currently hovered control.
    tooltip = function()
        if ugui.internal.hovered_control == nil then
            return
        end
        if (os.clock() - ugui.internal.hover_start_time) < ugui.standard_styler.params.tooltip.delay then
            return
        end

        -- Find hovered control
        for _, entry in pairs(ugui.internal.scene) do
            if entry.control.uid == ugui.internal.hovered_control then
                ugui.standard_styler.draw_tooltip(entry.control, {
                    x = ugui.internal.environment.mouse_position.x,
                    y = ugui.internal.environment.mouse_position.y,
                })
            end
        end
    end,

    ---Parses rich text into content segments.
    ---@param text RichText The rich text to parse.
    ---@return RichTextSegment[] # The content segments.
    parse_rich_text = function(text)
        local segments = {}
        local pattern = '(.-)(%[icon:([^%]:]+)(:?([^%]]*))%])'

        local last_pos = 1
        for before_text, full_icon, icon_name, _, color in text:gmatch(pattern) do
            if before_text ~= '' then
                table.insert(segments, {type = 'text', value = before_text})
            end
            if color:find('.') then
                -- The color is a path in standard_styler.params
                local result = ugui.standard_styler.params
                local index = 1
                local keys = {}
                for segment in color:gmatch('([^%.]+)') do
                    keys[#keys + 1] = segment
                end
                while index <= #keys and result do
                    result = result[keys[index]]
                    index = index + 1
                end
                color = result
            end
            table.insert(segments, {type = 'icon', value = icon_name, color = color ~= '' and color or nil})
            last_pos = last_pos + #before_text + #full_icon
        end

        if last_pos <= #text then
            local remaining_text = text:sub(last_pos)
            if remaining_text ~= '' then
                table.insert(segments, {type = 'text', value = remaining_text})
            end
        end

        return segments
    end,

    ---Does core input processing work, such as control capture/hover/click state management.
    do_input_processing = function()
        local function is_point_inside_rectangle(point, rectangle)
            return point.x >= rectangle.x and
                point.y >= rectangle.y and
                point.x <= rectangle.x + rectangle.width and
                point.y <= rectangle.y + rectangle.height
        end

        ---@type Control?
        local clicked_control = nil

        ---@type SceneEntry?
        local mouse_captured_control = nil
        for i = 1, #ugui.internal.scene, 1 do
            local entry = ugui.internal.scene[i]
            if entry.control.uid == ugui.internal.mouse_captured_control then
                mouse_captured_control = entry
            end
        end

        ---@type SceneEntry?
        local keyboard_captured_control = nil
        for i = 1, #ugui.internal.scene, 1 do
            local entry = ugui.internal.scene[i]
            if entry.control.uid == ugui.internal.keyboard_captured_control then
                keyboard_captured_control = entry
            end
        end


        local prev_hovered_control = ugui.internal.hovered_control
        ugui.internal.hovered_control = nil

        for i = #ugui.internal.scene, 1, -1 do
            local entry = ugui.internal.scene[i]
            local control = entry.control

            -- Determine the clicked control if we haven't already
            if clicked_control == nil then
                if ugui.internal.is_mouse_just_down() then
                    if is_point_inside_rectangle(ugui.internal.mouse_down_position, control.rectangle) then
                        clicked_control = control
                        keyboard_captured_control = entry
                        mouse_captured_control = entry
                    end
                end
            end

            -- Determine the hovered control if we haven't already
            if ugui.internal.hovered_control == nil then
                if is_point_inside_rectangle(ugui.internal.environment.mouse_position, control.rectangle) then
                    ugui.internal.hovered_control = control.uid

                    if ugui.internal.hovered_control ~= prev_hovered_control then
                        ugui.internal.hover_start_time = os.clock()
                    end
                end
            end
        end

        -- Clear the mouse captured control if we released the mouse
        if not ugui.internal.environment.is_primary_down then
            mouse_captured_control = nil
        end

        -- If we have a captured control, the hovered control must be locked to that as well.
        if mouse_captured_control ~= nil then
            ugui.internal.hovered_control = mouse_captured_control.control.uid
        end

        -- If the clicked control is disabled, we clear it now at the end of input processing, effectively "swallowing" the click.
        if clicked_control and clicked_control.is_enabled == false then
            clicked_control = nil
        end

        -- If we click outside of any control, we reset mouse and keyboard capture.
        if ugui.internal.is_mouse_just_down() and clicked_control == nil then
            mouse_captured_control = nil
            keyboard_captured_control = nil
        end

        -- Clear hovered control if it's disabled
        for i = 1, #ugui.internal.scene, 1 do
            local control = ugui.internal.scene[i].control
            if control.uid == ugui.internal.hovered_control
                and control.is_enabled == false then
                ugui.internal.hovered_control = nil
            end
        end

        -- Clear mouse captured control if it's disabled
        if mouse_captured_control and mouse_captured_control.control.is_enabled == false then
            mouse_captured_control = nil
        end

        -- Clear keyboard captured control if it's disabled
        if keyboard_captured_control and keyboard_captured_control.control.is_enabled == false then
            keyboard_captured_control = nil
        end

        ugui.internal.mouse_captured_control = mouse_captured_control and mouse_captured_control.control.uid or nil
        ugui.internal.keyboard_captured_control = keyboard_captured_control and keyboard_captured_control.control.uid or
            nil
        ugui.internal.clicked_control = clicked_control and clicked_control.uid or nil
    end,

    ---Gets the focus chain for a control or the scene.
    ---@param control Control? The control to get the focus chain for, or nil to get the focus chain for the scene.
    ---@return UguiFocusChain
    get_focus_chain = function(control)
        local min_uid = nil
        local max_uid = nil

        for _, entry in ipairs(ugui.internal.scene) do
            local control = entry.control

            if control.is_enabled == false then
                goto continue
            end

            if min_uid == nil or control.uid < min_uid then
                min_uid = control.uid
            end
            if max_uid == nil or control.uid > max_uid then
                max_uid = control.uid
            end

            ::continue::
        end

        if not control then
            return {previous = max_uid, next = min_uid}
        end

        local uid = control.uid
        local prev_uid = nil
        local next_uid = nil

        for _, entry in ipairs(ugui.internal.scene) do
            local control = entry.control
            local cid = control.uid

            if control.is_enabled == false then
                goto continue
            end

            if uid == nil then
                goto continue
            end

            if cid < uid then
                if prev_uid == nil or cid > prev_uid then
                    prev_uid = cid
                end
            elseif cid > uid then
                if next_uid == nil or cid < next_uid then
                    next_uid = cid
                end
            end

            ::continue::
        end

        if prev_uid == nil and max_uid ~= nil then
            prev_uid = max_uid
        end

        if next_uid == nil and min_uid ~= nil then
            next_uid = min_uid
        end

        if control.next_uid ~= nil then
            next_uid = control.next_uid

            while true do
                local next_control = ugui.internal.get_control_with_uid(next_uid)
                if not next_control then
                    break
                end

                if next_control.is_enabled == false then
                    local chain = ugui.internal.get_focus_chain(next_control)
                    next_uid = chain.next
                end

                break
            end
        end

        return {previous = prev_uid, next = next_uid}
    end,

    ---Gets the control with the given UID in the scene.
    ---@param uid UID?
    ---@return Control?
    get_control_with_uid = function(uid)
        if uid == nil then
            return nil
        end

        for i = 1, #ugui.internal.scene, 1 do
            local control = ugui.internal.scene[i].control
            if control.uid == uid then
                return control
            end
        end
        return nil
    end,

    ---Handles tab navigation.
    handle_tab_navigation = function()
        local keyboard_captured_control = ugui.internal.get_control_with_uid(ugui.internal.keyboard_captured_control)

        for _, e in pairs(ugui.internal.environment.key_events) do
            if e.keycode == ugui.keycodes.VK_TAB and e.pressed then
                local reverse = e.shift

                local chain = ugui.internal.get_focus_chain(keyboard_captured_control)

                if reverse then
                    ugui.internal.keyboard_captured_control = chain.previous
                else
                    ugui.internal.keyboard_captured_control = chain.next
                end
            end
        end
    end,
}
