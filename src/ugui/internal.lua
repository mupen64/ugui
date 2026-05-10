--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class SceneNode
---@field public control Control
---@field public type ControlType
---@field public parent SceneNode?
---@field public children SceneNode[]

ugui.internal = {
    ---@type SceneNode
    root = nil,

    ---@type SceneNode
    ---The current parent node for controls being placed. Reset to the root node each frame.
    current_parent = nil,

    ---@type table<UID, SceneNode>
    ---Cache of UID->SceneNode for the current frame.
    node_by_uid = {},

    ---@type table<UID, ControlType>
    control_types = {},

    ---@type table<UID, any>
    ---Map of control UIDs to their data.
    control_data = {},

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

    last_frame_time = 0,
    delta_time = 0,

    ---@type table<string, integer>
    ---Cache of nineslice drawings. Only used after calling `ugui.apply_nineslice`.
    nineslice_draw_cache = {},

    ---@type fun()[]
    events = {},

    ---Dispatches events related to controls in the scene.
    dispatch_events = function()
        for _, event in ipairs(ugui.internal.events) do
            event()
        end
        ugui.internal.events = {}
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

        local data = ugui.internal.control_data[control.uid]
        if not BreitbandGraphics.is_point_inside_rectangle(point, data.render_rect) then
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

        local hovered_node = ugui.internal.find_node(ugui.internal.hovered_control)

        if not hovered_node then
            return
        end

        if ugui.DEBUG and not hovered_node.control.tooltip then
            local base_text = string.format('%s (%d)', hovered_node.type, hovered_node.control.uid)
            local natural_size = ugui.internal.control_data[hovered_node.control.uid].natural_size
            local render_rect = ugui.internal.control_data[hovered_node.control.uid].render_rect
            local parent_text = hovered_node.parent and string.format('%s (%d)', hovered_node.parent.type, hovered_node.parent.control.uid) or 'none'
            hovered_node.control.tooltip = string.format('%s\nnatural_size: %.0f x %.0f\nrender_rect: %.0f %.0f | %.0f x %.0f\nparent: %s',
                base_text,
                natural_size.x, natural_size.y,
                render_rect.x, render_rect.y, render_rect.width, render_rect.height,
                parent_text)
        end

        ugui.standard_styler.draw_tooltip(hovered_node.control, {
            x = ugui.internal.environment.mouse_position.x,
            y = ugui.internal.environment.mouse_position.y,
        })
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

    ---Computes the effective value of a control property, respecting instance-level
    ---overrides, registry-level defaults, and a fallback default.
    ---@param control Control
    ---@param registry_entry ControlRegistryEntry
    ---@param prop_name string
    ---@param get_default fun(): any
    ---@return any
    compute_prop = function(control, registry_entry, prop_name, get_default)
        if control[prop_name] ~= nil then
            return control[prop_name]
        elseif registry_entry[prop_name] ~= nil then
            return registry_entry[prop_name](control)
        end
        return get_default()
    end,

    ---Does core input processing work, such as control capture/hover/click state management.
    do_input_processing = function()
        local function is_point_inside_rectangle(point, rectangle)
            return point.x >= rectangle.x and
                point.y >= rectangle.y and
                point.x <= rectangle.x + rectangle.width and
                point.y <= rectangle.y + rectangle.height
        end

        local function traverse_tree_reversed(node, callback)
            for i = #node.children, 1, -1 do
                traverse_tree_reversed(node.children[i], callback)
            end

            callback(node)
        end

        ---@type Control?
        local clicked_control = nil

        ---@type SceneNode?
        local mouse_captured_control = nil
        if ugui.internal.mouse_captured_control then
            mouse_captured_control = ugui.internal.find_node(ugui.internal.mouse_captured_control)
        end

        ---@type SceneNode?
        local keyboard_captured_control = nil
        if ugui.internal.keyboard_captured_control then
            keyboard_captured_control = ugui.internal.find_node(ugui.internal.keyboard_captured_control)
        end

        local prev_hovered_control = ugui.internal.hovered_control
        ugui.internal.hovered_control = nil

        traverse_tree_reversed(ugui.internal.root, function(node)
            local control = node.control
            local data = ugui.internal.control_data[control.uid]
            local registry_entry = ugui.registry[node.type]

            local effective_hittestable = ugui.internal.compute_prop(control, registry_entry, 'hittestable', function() return true end)

            -- Determine the clicked control if we haven't already
            if clicked_control == nil and effective_hittestable then
                if ugui.internal.is_mouse_just_down() then
                    if is_point_inside_rectangle(ugui.internal.mouse_down_position, data.render_rect) then
                        clicked_control = control
                        keyboard_captured_control = node
                        mouse_captured_control = node
                    end
                end
            end

            -- Determine the hovered control if we haven't already
            if ugui.internal.hovered_control == nil and effective_hittestable then
                if is_point_inside_rectangle(ugui.internal.environment.mouse_position, data.render_rect) then
                    ugui.internal.hovered_control = control.uid

                    if ugui.internal.hovered_control ~= prev_hovered_control then
                        ugui.internal.hover_start_time = os.clock()
                    end
                end
            end
        end)

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
        local hovered_node = ugui.internal.hovered_control and ugui.internal.find_node(ugui.internal.hovered_control) or nil
        if hovered_node and hovered_node.control.is_enabled == false then
            ugui.internal.hovered_control = nil
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
        ugui.internal.keyboard_captured_control = keyboard_captured_control and keyboard_captured_control.control.uid or nil
        ugui.internal.clicked_control = clicked_control and clicked_control.uid or nil
    end,

    ---Measures the specified node.
    ---@param node SceneNode
    ---@return Vector2
    measure = function(node)
        -- We cache the natural sizes per-frame because they can be REALLY expensive to compute and we'd churn through these up to like 5 times depending on depth.
        if ugui.internal.control_data[node.control.uid].natural_size then
            return ugui.internal.control_data[node.control.uid].natural_size
        end

        local registry_entry = ugui.registry[node.type]

        local revert_styler_mixin = ugui.internal.apply_styler_mixin(node.control)
        local size
        if registry_entry.measure then
            size = registry_entry.measure(node)
        else
            size = ugui.internal.measure_fit_biggest_child(node)
        end
        revert_styler_mixin()

        ugui.internal.control_data[node.control.uid].natural_size = size
        return size
    end,

    ---Default measure implementation that fits the biggest child node recursively.
    ---@param node SceneNode
    ---@return Vector2
    measure_fit_biggest_child = function(node)
        local biggest = {x = 0, y = 0}
        for _, child in pairs(node.children) do
            local size = ugui.internal.measure(child)
            biggest.x = math.max(biggest.x, size.x)
            biggest.y = math.max(biggest.y, size.y)
        end
        return biggest
    end,

    ---Performs scene layout.
    layout = function()
        ugui.internal.foreach_node_from_root(function(node)
            ugui.internal.control_data[node.control.uid].natural_size = nil
        end)

        ugui.internal.foreach_node_from_root(function(node)
            ugui.internal.control_data[node.control.uid].natural_size = ugui.internal.measure(node)
        end)

        -- Apply padding to natural size...
        ugui.internal.foreach_node_from_root(function(node)
            local data = ugui.internal.control_data[node.control.uid]
            local padding = node.control.padding and ugui.internal.resolve_unit2(node.control.padding, node) or {x = 0, y = 0}

            data.natural_size.x = data.natural_size.x + padding.x * 2
            data.natural_size.y = data.natural_size.y + padding.y * 2
        end)

        ugui.internal.foreach_node_from_root(function(node)
            local control = node.control
            if control.margin then
                local pos = ugui.internal.resolve_unit2(control.margin, node)
                control.rectangle.x = pos.x
                control.rectangle.y = pos.y
            end
            if control.size then
                local size = ugui.internal.resolve_unit2(control.size, node)
                control.rectangle.width = size.x
                control.rectangle.height = size.y
            end
        end)

        -- This one is nuts: we have to emulate a flex-col with wrapping before we have an actual implementation for it...
        -- And even better that we have to feed content_rect back to it so it can return that...
        -- Absolutely NUTS design, this control's needs to be EXECUTED before 4.0.0
        --
        -- oh we also need to re-run the margin/size computation pass...
        local function tabcontrol_hack_1()
            ugui.internal.foreach_node_from_root(function(node)
                local data = ugui.internal.control_data[node.control.uid]

                if node.type == 'panel' and data.is_tab_control then
                    local revert_styler_mixin = ugui.internal.apply_styler_mixin(node.control)

                    local child_uid = node.control.uid + 1
                    local x = 0
                    local y = 0

                    for _, __ in pairs(node.control.items) do
                        local child_data = ugui.internal.control_data[child_uid]
                        local child_node = ugui.internal.find_node(child_uid)

                        if x + child_data.natural_size.x > node.control.rectangle.width then
                            x = 0
                            y = y + ugui.standard_styler.params.tabcontrol.rail_size + ugui.standard_styler.params.tabcontrol.gap_y
                        end

                        child_node.control.margin = string.format('%fpx %fpx', x, y)

                        x = x + child_data.natural_size.x + ugui.standard_styler.params.tabcontrol.gap_x

                        child_uid = child_uid + 2
                    end

                    data.rail_height = y + ugui.standard_styler.params.tabcontrol.rail_size - node.control.rectangle.y

                    revert_styler_mixin()
                end
            end)

            ugui.internal.foreach_node_from_root(function(node)
                local control = node.control
                if control.margin then
                    local pos = ugui.internal.resolve_unit2(control.margin, node)
                    control.rectangle.x = pos.x
                    control.rectangle.y = pos.y
                end
                if control.size then
                    local size = ugui.internal.resolve_unit2(control.size, node)
                    control.rectangle.width = size.x
                    control.rectangle.height = size.y
                end
            end)
        end

        tabcontrol_hack_1()

        ugui.internal.foreach_node_from_root(function(node)
            local control = node.control
            local parent = node.parent

            local parent_rect = parent and parent.control.rectangle or {x = 0, y = 0, width = 0, height = 0}

            local min_x<const> = parent_rect.x
            local max_x<const> = min_x + parent_rect.width - control.rectangle.width

            local min_y<const> = parent_rect.y
            local max_y<const> = min_y + parent_rect.height - control.rectangle.height

            local align = ugui.internal.resolve_alignment2(control.align)
            local x_offset<const> = ugui.internal.remap(align.x, 0, 1, min_x, max_x)
            local y_offset<const> = ugui.internal.remap(align.y, 0, 1, min_y, max_y)

            control.rectangle.x = control.rectangle.x + x_offset
            control.rectangle.y = control.rectangle.y + y_offset
        end)

        ugui.internal.foreach_node_from_root(function(node)
            local data = ugui.internal.control_data[node.control.uid]
            data.render_rect = {x = node.control.rectangle.x, y = node.control.rectangle.y, width = node.control.rectangle.width, height = node.control.rectangle.height}
        end)

        -- HACK: We need to manipulate various controls to emulate a flex layout... it's only coming in a future pr lol
        ugui.internal.foreach_node_from_root(function(node)
            local data = ugui.internal.control_data[node.control.uid]

            if node.type == 'listbox' then
                local x_overflow<const> = data.natural_size.x > data.render_rect.width
                local y_overflow<const> = data.natural_size.y > data.render_rect.height
                local scrollbar_1_uid<const> = node.control.uid + 1
                local scrollbar_2_uid<const> = node.control.uid + 2
                local scrollbar_1_data = ugui.internal.control_data[scrollbar_1_uid]
                local scrollbar_2_data = ugui.internal.control_data[scrollbar_2_uid]

                if x_overflow and scrollbar_1_data then
                    data.render_rect.width = data.render_rect.width - ugui.standard_styler.params.scrollbar.thickness
                end
                if y_overflow and scrollbar_2_data then
                    data.render_rect.height = data.render_rect.height - ugui.standard_styler.params.scrollbar.thickness
                end
            end

            if node.type == 'numberbox' and node.control.show_negative then
                local button_uid<const> = node.control.uid + 1
                local button_data<const> = ugui.internal.control_data[button_uid]
                data.render_rect.x = data.render_rect.x + button_data.render_rect.width
                data.render_rect.width = data.render_rect.width - button_data.render_rect.width
            end

            -- Overflow avoidance: shift the X/Y position to avoid going out of bounds
            if node.type == 'menu' then
                local parent_is_menu = node.parent.control.type == 'menu'
                local parent_render_rect = ugui.internal.control_data[node.parent.control.uid].render_rect

                if data.render_rect.x + data.render_rect.width > ugui.internal.environment.window_size.x then
                    if parent_is_menu then
                        data.render_rect.x = parent_render_rect.x - data.render_rect.width +
                            ugui.standard_styler.params.menu.overlap_size
                    else
                        data.render_rect.x = data.render_rect.x -
                            (data.render_rect.x + data.render_rect.width - ugui.internal.environment.window_size.x)
                    end
                end
                if data.render_rect.y + data.render_rect.height > ugui.internal.environment.window_size.y then
                    data.render_rect.y = data.render_rect.y -
                        (data.render_rect.y + data.render_rect.height - ugui.internal.environment.window_size.y)
                end
            end

            if node.type == 'panel' and data.is_tab_control then
                data.content_rect = {x = data.render_rect.x, y = data.render_rect.y + data.rail_height, width = data.render_rect.width, height = data.render_rect.height - data.rail_height}
            end
        end)
    end,

    render = function()
        ugui.internal.foreach_node_from_root(function(node)
            local control = node.control
            local type = node.type

            local data = ugui.internal.control_data[node.control.uid]
            local render_rect = data.render_rect

            local entry = ugui.registry[type]

            if entry.draw then
                local revert_styler_mixin = ugui.internal.apply_styler_mixin(control)
                entry.draw(control)
                revert_styler_mixin()
            end

            if ugui.DEBUG then
                BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(render_rect, 0), '#FF0000', 1)
                -- BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle({x = render_rect.x, y = render_rect.y, width = data.natural_size.x, height = data.natural_size.y}, 0), '#0000FF', 4)

                if ugui.internal.keyboard_captured_control == control.uid then
                    BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(render_rect, 4), '#000000', 2)
                end
                if ugui.internal.mouse_captured_control == control.uid then
                    BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(render_rect, 8), '#FF0000', 2)
                end
            end
        end)
    end,

    ---Places a control into the scene.
    ---@param control Control
    ---@param type ControlType
    ---@param fn ContentSlotCallback?
    ---@return ControlReturnValue
    place_control = function(control, type, fn)
        local registry_entry = ugui.registry[type]
        ugui.internal.assert(registry_entry ~= nil, string.format("Unknown control type '%s'", type))

        -- Check for UID reuse.
        if ugui.internal.node_by_uid[control.uid] then
            ugui.internal.assert(false, string.format('Attempted to show a control with uid %d, which is already in use! Note that some controls reserve more than one uid slot after them.', control.uid))
        end

        -- Check for cross-frame control type clobbering (e.g. button becoming a textbox)
        local stored_control_type = ugui.internal.control_types[control.uid]
        if stored_control_type then
            ugui.internal.assert(stored_control_type == type,
                string.format('Attempted to reuse UID %d of %s for %s.', control.uid, stored_control_type, type))
        end

        local return_value = {primary = nil, meta = {signal_change = ugui.signal_change_states.none}}
        local has_root<const> = ugui.internal.root ~= nil

        ---@type SceneNode
        local this_node = {
            control = control,
            type = type,
            parent = ugui.internal.current_parent,
            children = {},
        }

        ugui.internal.node_by_uid[control.uid] = this_node

        -- Disable the control if any parent is disabled.
        local node = ugui.internal.current_parent
        while node do
            if node.control.is_enabled == false then
                control.is_enabled = false
                break
            end
            node = node.parent
        end

        if not control.rectangle then
            control.rectangle = {x = 0, y = 0, width = 0, height = 0}
            control.margin = control.margin or '0px'
            control.size = control.size or 'auto'
        end

        local revert_styler_mixin = ugui.internal.apply_styler_mixin(control)

        -- If the control has only just been added, we run its setup.
        if ugui.internal.control_data[control.uid] == nil then
            ugui.internal.control_data[control.uid] = {
                signal_change = ugui.signal_change_states.none,
                natural_size = {x = 0, y = 0},
                render_rect = {x = 0, y = 0, width = 0, height = 0},
            }

            if registry_entry.setup then
                registry_entry.setup(control, ugui.internal.control_data[control.uid])
            end

            -- Run logic once to stabilize the return value for the first state.
            if registry_entry.logic then
                return_value = registry_entry.logic(control, ugui.internal.control_data[control.uid])
            end
        end

        if not has_root then
            ugui.internal.root = this_node
            ugui.internal.current_parent = this_node
        end

        if registry_entry.validate then
            registry_entry.validate(control)
        end

        if has_root then
            ugui.internal.current_parent.children[#ugui.internal.current_parent.children + 1] = this_node
        end
        ugui.internal.control_types[control.uid] = type

        if registry_entry.logic then
            return_value = registry_entry.logic(control, ugui.internal.control_data[control.uid])
        end

        revert_styler_mixin()

        if fn then
            local prev_parent = ugui.internal.current_parent
            ugui.internal.current_parent = this_node
            fn()
            ugui.internal.current_parent = prev_parent
        end

        return return_value
    end,

}
