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
    mouse_down_position = { x = 0, y = 0 },

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

    ---Asserts that the specified condition is true, printing the stacktrace if it's false.
    ---@param condition boolean
    ---@param message string
    assert = function(condition, message)
        if condition then
            return
        end
        print(debug.traceback())
        assert(condition, message)
    end,

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

    ---Deeply clones a table.
    ---@param obj table The table to clone.
    ---@param seen table? Internal. Pass nil as a caller.
    ---@return table A cloned instance of the table.
    deep_clone = function(obj, seen)
        if type(obj) ~= 'table' then return obj end
        if seen and seen[obj] then return seen[obj] end
        local s = seen or {}
        local res = setmetatable({}, getmetatable(obj))
        s[obj] = res
        for k, v in pairs(obj) do
            res[ugui.internal.deep_clone(k, s)] = ugui.internal.deep_clone(
                v, s)
        end
        return res
    end,

    ---Merges two tables deeply, mutating the second table with the first table's values, giving precedence to the first table's values.
    ---@param a table The override table, whose values take precedence.
    ---@param b table The source and target table, mutated in-place.
    ---@return function A function that rolls back all changes made to b.
    deep_merge = function(a, b)
        local rollback_ops = {}

        local function merge(t1, t2)
            for key, value in pairs(t1) do
                if type(value) == 'table' and type(t2[key]) == 'table' then
                    merge(value, t2[key])
                else
                    local prev = t2[key]
                    t2[key] = value
                    local t2_ref = t2
                    local k = key
                    rollback_ops[#rollback_ops + 1] = function()
                        t2_ref[k] = prev
                    end
                end
            end
        end

        merge(a, b)

        return function()
            for i = #rollback_ops, 1, -1 do
                rollback_ops[i]()
            end
        end
    end,

    ---Performs an in-place stable sort on the specified table.
    ---@generic T
    ---@param t T[]
    ---@param cmp? fun(a: T, b: T):boolean
    stable_sort = function(t, cmp)
        local function merge(left, right)
            local result = {}
            local i, j = 1, 1

            while i <= #left and j <= #right do
                -- If left < right, or they are "equal" (cmp false both ways),
                -- take from the left to preserve stability
                if cmp(left[i], right[j]) or (not cmp(right[j], left[i])) then
                    table.insert(result, left[i])
                    i = i + 1
                else
                    table.insert(result, right[j])
                    j = j + 1
                end
            end

            while i <= #left do
                table.insert(result, left[i])
                i = i + 1
            end
            while j <= #right do
                table.insert(result, right[j])
                j = j + 1
            end

            return result
        end

        local function mergesort(arr)
            if #arr <= 1 then return arr end
            local mid = math.floor(#arr / 2)
            local left, right = {}, {}
            for i = 1, mid do table.insert(left, arr[i]) end
            for i = mid + 1, #arr do table.insert(right, arr[i]) end
            return merge(mergesort(left), mergesort(right))
        end

        local sorted = mergesort(t)
        for i = 1, #t do
            t[i] = sorted[i]
        end
    end,

    ---Removes a range of characters from a string.
    ---@param string string The string to remove characters from.
    ---@param start_index integer The index of the first character to remove.
    ---@param end_index integer The index of the last character to remove.
    ---@return string # A new string with the characters removed.
    remove_range = function(string, start_index, end_index)
        if start_index > end_index then
            start_index, end_index = end_index, start_index
        end
        return string.sub(string, 1, start_index - 1) .. string.sub(string, end_index)
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

    ---Removes the character at the specified index from a string.
    ---@param string string The string to remove the character from.
    ---@param index integer The index of the character to remove.
    ---@return string # A new string with the character removed.
    remove_at = function(string, index)
        if index == 0 then
            return string
        end
        return string:sub(1, index - 1) .. string:sub(index + 1, string:len())
    end,

    ---Inserts a string into another string at the specified index.
    ---@param string string The original string to insert the other string into.
    ---@param string2 string The other string.
    ---@param index integer The index into the first string to begin inserting the second string at.
    ---@return string # A new string with the other string inserted.
    insert_at = function(string, string2, index)
        return string:sub(1, index) .. string2 .. string:sub(index + string2:len(), string:len())
    end,

    ---Gets the digit at a specific index in a number with a specific padded length.
    ---@param value integer The number.
    ---@param length integer The number's padded length (number of digits).
    ---@param index integer The index to get digit from.
    ---@return integer # The digit at the specified index.
    get_digit = function(value, length, index)
        return math.floor(value / math.pow(10, length - index)) % 10
    end,

    ---Sets the digit at a specific index in a number with a specific padded length.
    ---@param value integer The number.
    ---@param length integer The number's padded length (number of digits).
    ---@param digit_value integer The new digit value.
    ---@param index integer The index to get digit from.
    ---@return integer # The new number.
    set_digit = function(value, length, digit_value, index)
        local old_digit_value = ugui.internal.get_digit(value, length, index)
        local new_value = value + (digit_value - old_digit_value) * math.pow(10, length - index)
        local max = math.pow(10, length)
        return (new_value + max) % max
    end,

    ---Remaps a value from one range to another.
    ---@param value number The value.
    ---@param from1 number The lower bound of the first range.
    ---@param to1 number The upper bound of the first range.
    ---@param from2 number The lower bound of the second range.
    ---@param to2 number The upper bound of the second range.
    ---@return number # The new remapped value.
    remap = function(value, from1, to1, from2, to2)
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2
    end,

    ---Limits a value to a range.
    ---@param value number The value.
    ---@param min number The lower bound.
    ---@param max number The upper bound.
    ---@return number # The new limited value.
    clamp = function(value, min, max)
        return math.max(math.min(value, max), min)
    end,

    ---Gets all the keys that are newly pressed since the last frame.
    ---@return table<string, boolean> # The newly pressed keys.
    get_just_pressed_keys = function()
        local keys = {}
        for key, _ in pairs(ugui.internal.environment.held_keys) do
            if not ugui.internal.previous_environment.held_keys[key] then
                keys[key] = 1
            end
        end
        return keys
    end,

    ---Gets the character index for the specified relative x position in a textbox.
    ---Considers font_size and font_name, as provided by the styler.
    ---@param text string The textbox's text.
    ---@param relative_x number The relative x position.
    ---@return integer The character index.
    ---FIXME: This should be moved to BreitbandGraphics!!!
    get_caret_index = function(text, relative_x)
        local positions = {}
        for i = 1, #text, 1 do
            local width = BreitbandGraphics.get_text_size(text:sub(1, i),
                ugui.standard_styler.params.font_size,
                ugui.standard_styler.params.font_name).width

            positions[#positions + 1] = width
        end

        for i = #positions, 1, -1 do
            if relative_x > positions[i] then
                return ugui.internal.clamp(i + 1, 1, #positions + 1)
            end
        end

        return 1
    end,

    ---Handles navigation key presses in a textbox.
    ---@param key string The pressed key identifier.
    ---@param has_selection boolean Whether the textbox has a selection.
    ---@param text string The textbox's text.
    ---@param selection_start integer The textbox selection start index.
    ---@param selection_end integer The textbox selection end index.
    ---@param caret_index integer The textbox caret index.
    ---@return TextBoxNavigationKeyProcessingResult # The result of the navigation key press processing.
    handle_special_key = function(key, has_selection, text, selection_start, selection_end, caret_index)
        local sel_lo = math.min(selection_start, selection_end)
        local sel_hi = math.max(selection_start, selection_end)

        if key == 'left' then
            if has_selection then
                -- nuke the selection and set caret index to lower (left)
                local lower_selection = sel_lo
                selection_start = lower_selection
                selection_end = lower_selection
                caret_index = lower_selection
            else
                caret_index = caret_index - 1
            end
        elseif key == 'right' then
            if has_selection then
                -- nuke the selection and set caret index to higher (right)
                local higher_selection = sel_hi
                selection_start = higher_selection
                selection_end = higher_selection
                caret_index = higher_selection
            else
                caret_index = caret_index + 1
            end
        elseif key == 'space' then
            if has_selection then
                -- replace selection contents by one space
                local lower_selection = sel_lo
                text = ugui.internal.remove_range(text, sel_lo, sel_hi)
                caret_index = lower_selection
                selection_start = lower_selection
                selection_end = lower_selection
                text = ugui.internal.insert_at(text, ' ', caret_index - 1)
                caret_index = caret_index + 1
            else
                text = ugui.internal.insert_at(text, ' ', caret_index - 1)
                caret_index = caret_index + 1
            end
        elseif key == 'backspace' then
            if has_selection then
                local lower_selection = sel_lo
                text = ugui.internal.remove_range(text, lower_selection, sel_hi)
                caret_index = lower_selection
                selection_start = lower_selection
                selection_end = lower_selection
            else
                text = ugui.internal.remove_at(text,
                    caret_index - 1)
                caret_index = caret_index - 1
            end
        else
            return {
                handled = false,
            }
        end
        return {
            handled = true,
            text = text,
            selection_start = selection_start,
            selection_end = selection_end,
            caret_index = caret_index,
        }
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
                table.insert(segments, { type = 'text', value = before_text })
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
            table.insert(segments, { type = 'icon', value = icon_name, color = color ~= '' and color or nil })
            last_pos = last_pos + #before_text + #full_icon
        end

        if last_pos <= #text then
            local remaining_text = text:sub(last_pos)
            if remaining_text ~= '' then
                table.insert(segments, { type = 'text', value = remaining_text })
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
}
