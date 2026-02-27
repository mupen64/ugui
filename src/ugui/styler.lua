--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

--- The standard style implementation, which is responsible for drawing controls.
ugui.standard_styler = {

    --- The styler parameters, which determine how controls are drawn.
    params = {

        --- Whether font filtering is enabled.
        cleartype = true,

        --- The font name.
        font_name = 'MS Shell Dlg 2',

        --- The monospace variant font name.
        monospace_font_name = 'Consolas',

        --- The color filter used for rendering controls. Only applies to cached control rendering using ugui-ext.
        color_filter = BreitbandGraphics.hex_to_color('#FFFFFFFF'),

        --- The font size.
        font_size = 12,

        --- The icon size.
        icon_size = 12,

        button = {
            back = {
                [1] = BreitbandGraphics.hex_to_color('#E1E1E1'),
                [2] = BreitbandGraphics.hex_to_color('#E5F1FB'),
                [3] = BreitbandGraphics.hex_to_color('#CCE4F7'),
                [0] = BreitbandGraphics.hex_to_color('#CCCCCC'),
            },
            border = {
                [1] = BreitbandGraphics.hex_to_color('#ADADAD'),
                [2] = BreitbandGraphics.hex_to_color('#0078D7'),
                [3] = BreitbandGraphics.hex_to_color('#005499'),
                [0] = BreitbandGraphics.hex_to_color('#BFBFBF'),
            },
            text = {
                [1] = BreitbandGraphics.hex_to_color('#000000'),
                [2] = BreitbandGraphics.hex_to_color('#000000'),
                [3] = BreitbandGraphics.hex_to_color('#000000'),
                [0] = BreitbandGraphics.hex_to_color('#A0A0A0'),
            },
        },
        textbox = {
            padding = { x = 2, y = 0 },
            back = {
                [1] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [2] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [3] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [0] = BreitbandGraphics.hex_to_color('#FFFFFF'),
            },
            border = {
                [1] = BreitbandGraphics.hex_to_color('#7A7A7A'),
                [2] = BreitbandGraphics.hex_to_color('#171717'),
                [3] = BreitbandGraphics.hex_to_color('#0078D7'),
                [0] = BreitbandGraphics.hex_to_color('#CCCCCC'),
            },
            text = {
                [1] = BreitbandGraphics.hex_to_color('#000000'),
                [2] = BreitbandGraphics.hex_to_color('#000000'),
                [3] = BreitbandGraphics.hex_to_color('#000000'),
                [0] = BreitbandGraphics.hex_to_color('#A0A0A0'),
            },
            selection = BreitbandGraphics.hex_to_color('#0078D7'),
        },
        listbox = {
            back = {
                [1] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [2] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [3] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [0] = BreitbandGraphics.hex_to_color('#FFFFFF'),
            },
            border = {
                [1] = BreitbandGraphics.hex_to_color('#7A7A7A'),
                [2] = BreitbandGraphics.hex_to_color('#7A7A7A'),
                [3] = BreitbandGraphics.hex_to_color('#7A7A7A'),
                [0] = BreitbandGraphics.hex_to_color('#7A7A7A'),
            },
        },
        listbox_item = {
            height = 15,
            back = {
                [1] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [2] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [3] = BreitbandGraphics.hex_to_color('#0078D7'),
                [0] = BreitbandGraphics.hex_to_color('#FFFFFF'),
            },
            text = {
                [1] = BreitbandGraphics.hex_to_color('#000000'),
                [2] = BreitbandGraphics.hex_to_color('#000000'),
                [3] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [0] = BreitbandGraphics.hex_to_color('#A0A0A0'),
            },
        },
        menu = {
            overlap_size = 3,
            back = {
                [1] = BreitbandGraphics.hex_to_color('#F2F2F2'),
                [2] = BreitbandGraphics.hex_to_color('#F2F2F2'),
                [3] = BreitbandGraphics.hex_to_color('#F2F2F2'),
                [0] = BreitbandGraphics.hex_to_color('#F2F2F2'),
            },
            border = {
                [1] = BreitbandGraphics.hex_to_color('#CCCCCC'),
                [2] = BreitbandGraphics.hex_to_color('#CCCCCC'),
                [3] = BreitbandGraphics.hex_to_color('#CCCCCC'),
                [0] = BreitbandGraphics.hex_to_color('#CCCCCC'),
            },
        },
        menu_item = {
            height = 22,
            left_padding = 32,
            right_padding = 32,
            back = {
                [1] = BreitbandGraphics.hex_to_color('#00000000'),
                [2] = BreitbandGraphics.hex_to_color('#91C9F7'),
                [3] = BreitbandGraphics.hex_to_color('#91C9F7'),
                [0] = BreitbandGraphics.hex_to_color('#00000000'),
            },
            border = {
                [1] = BreitbandGraphics.hex_to_color('#CCCCCC'),
                [2] = BreitbandGraphics.hex_to_color('#CCCCCC'),
                [3] = BreitbandGraphics.hex_to_color('#CCCCCC'),
                [0] = BreitbandGraphics.hex_to_color('#CCCCCC'),
            },
            text = {
                [1] = BreitbandGraphics.hex_to_color('#000000'),
                [2] = BreitbandGraphics.hex_to_color('#000000'),
                [3] = BreitbandGraphics.hex_to_color('#000000'),
                [0] = BreitbandGraphics.hex_to_color('#6D6D6D'),
            },
        },
        joystick = {
            tip_size = 8,
            back = {
                [1] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [2] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [3] = BreitbandGraphics.hex_to_color('#FFFFFF'),
                [0] = BreitbandGraphics.hex_to_color('#FFFFFF'),
            },
            outline = {
                [1] = BreitbandGraphics.hex_to_color('#000000'),
                [2] = BreitbandGraphics.hex_to_color('#000000'),
                [3] = BreitbandGraphics.hex_to_color('#000000'),
                [0] = BreitbandGraphics.hex_to_color('#000000'),
            },
            tip = {
                [1] = BreitbandGraphics.hex_to_color('#FF0000'),
                [2] = BreitbandGraphics.hex_to_color('#FF0000'),
                [3] = BreitbandGraphics.hex_to_color('#FF0000'),
                [0] = BreitbandGraphics.hex_to_color('#FF8080'),
            },
            line = {
                [1] = BreitbandGraphics.hex_to_color('#0000FF'),
                [2] = BreitbandGraphics.hex_to_color('#0000FF'),
                [3] = BreitbandGraphics.hex_to_color('#0000FF'),
                [0] = BreitbandGraphics.hex_to_color('#8080FF'),
            },
            inner_mag = {
                [1] = BreitbandGraphics.hex_to_color('#FF000022'),
                [2] = BreitbandGraphics.hex_to_color('#FF000022'),
                [3] = BreitbandGraphics.hex_to_color('#FF000022'),
                [0] = BreitbandGraphics.hex_to_color('#00000000'),
            },
            outer_mag = {
                [1] = BreitbandGraphics.hex_to_color('#FF0000'),
                [2] = BreitbandGraphics.hex_to_color('#FF0000'),
                [3] = BreitbandGraphics.hex_to_color('#FF0000'),
                [0] = BreitbandGraphics.hex_to_color('#FF8080'),
            },
            mag_thicknesses = {
                [1] = 2,
                [2] = 2,
                [3] = 2,
                [0] = 2,
            },
        },
        scrollbar = {
            thickness = 17,
            back = {
                [1] = BreitbandGraphics.hex_to_color('#F0F0F0'),
                [2] = BreitbandGraphics.hex_to_color('#F0F0F0'),
                [3] = BreitbandGraphics.hex_to_color('#F0F0F0'),
                [0] = BreitbandGraphics.hex_to_color('#F0F0F0'),
            },
            thumb = {
                [1] = BreitbandGraphics.hex_to_color('#CDCDCD'),
                [2] = BreitbandGraphics.hex_to_color('#A6A6A6'),
                [3] = BreitbandGraphics.hex_to_color('#606060'),
                [0] = BreitbandGraphics.hex_to_color('#C0C0C0'),
            },
        },
        trackbar = {
            track_thickness = 2,
            bar_width = 6,
            bar_height = 16,
            back = {
                [1] = BreitbandGraphics.hex_to_color('#E7EAEA'),
                [2] = BreitbandGraphics.hex_to_color('#E7EAEA'),
                [3] = BreitbandGraphics.hex_to_color('#E7EAEA'),
                [0] = BreitbandGraphics.hex_to_color('#E7EAEA'),
            },
            border = {
                [1] = BreitbandGraphics.hex_to_color('#D6D6D6'),
                [2] = BreitbandGraphics.hex_to_color('#D6D6D6'),
                [3] = BreitbandGraphics.hex_to_color('#D6D6D6'),
                [0] = BreitbandGraphics.hex_to_color('#D6D6D6'),
            },
            thumb = {
                [1] = BreitbandGraphics.hex_to_color('#007AD9'),
                [2] = BreitbandGraphics.hex_to_color('#171717'),
                [3] = BreitbandGraphics.hex_to_color('#CCCCCC'),
                [0] = BreitbandGraphics.hex_to_color('#CCCCCC'),
            },
        },
        tooltip = {
            delay = 0.2,
            padding = 4,
        },
        spinner = {
            button_size = 15,
        },
        tabcontrol = {
            rail_size = 17,
            draw_frame = true,
            gap_x = 0,
            gap_y = 0,
        },
        numberbox = {
            font_scale = 1.5,
            selection = BreitbandGraphics.hex_to_color('#0078D7'),
        },
    },

    ---Draws an icon with the specified parameters.
    ---The draw_icon implementation may choose to use either the color or visual_state parameter to determine the icon's appearance.
    ---Therefore, the caller must provide either a color or a visual state, or both.
    ---@param rectangle Rectangle The icon's bounds.
    ---@param color ColorSource? The icon's fill color.
    ---@param visual_state VisualState? The icon's visual state.
    ---@param key string The icon's identifier.
    draw_icon = function(rectangle, color, visual_state, key)
        -- NOTE: visual_state is not utilized by the standard implementation of draw_icon.
        if not color then
            BreitbandGraphics.fill_rectangle(rectangle, BreitbandGraphics.colors.red)
            return
        end

        local font_name = 'Segoe UI Mono'
        local font_size = ugui.standard_styler.params.font_size

        if key == 'arrow_left' then
            BreitbandGraphics.draw_text2({
                text = '<',
                rectangle = rectangle,
                color = color,
                font_name = font_name,
                font_size = font_size,
                aliased = not ugui.standard_styler.params.cleartype,
            })
        elseif key == 'arrow_right' then
            BreitbandGraphics.draw_text2({
                text = '>',
                rectangle = rectangle,
                color = color,
                font_name = font_name,
                font_size = font_size,
                aliased = not ugui.standard_styler.params.cleartype,
            })
        elseif key == 'arrow_up' then
            BreitbandGraphics.draw_text2({
                text = '^',
                rectangle = rectangle,
                color = color,
                font_name = font_name,
                font_size = font_size,
                aliased = not ugui.standard_styler.params.cleartype,
            })
        elseif key == 'arrow_down' then
            BreitbandGraphics.draw_text2({
                text = 'v',
                rectangle = rectangle,
                color = color,
                font_name = font_name,
                font_size = font_size,
                aliased = not ugui.standard_styler.params.cleartype,
            })
        elseif key == 'checkmark' then
            local connection_point = { x = rectangle.x + rectangle.width * 0.3, y = rectangle.y + rectangle.height }
            BreitbandGraphics.draw_line({ x = rectangle.x, y = rectangle.y + rectangle.height / 2 }, connection_point,
                color, 1)
            BreitbandGraphics.draw_line(connection_point, { x = rectangle.x + rectangle.width, y = rectangle.y }, color,
                1)
        else
            -- Unknown icon, probably a good idea to nag the user
            BreitbandGraphics.fill_rectangle(rectangle, BreitbandGraphics.colors.red)
        end
    end,

    ---Computes the segment data of rich text.
    ---@param text RichText The rich text.
    ---@param plaintext boolean? Whether the text is drawn without rich formatting. If nil, false is assumed.
    ---@return { segment_data: { segment: RichTextSegment, rectangle: Rectangle }[], size: Vector2  } # The computed rich text segment data.
    compute_rich_text = function(text, plaintext)
        if not text then
            return { segment_data = {}, size = { x = 0, y = 0 } }
        end

        if plaintext then
            local size = BreitbandGraphics.get_text_size(text, ugui.standard_styler.params.font_size,
                ugui.standard_styler.params.font_name)
            return {
                segment_data = {
                    segment = {
                        type = 'text',
                        value = text,
                    },
                    rectangle = {
                        x = 0,
                        y = 0,
                        width = size.width,
                        height = size.height,
                    },
                },
                size = {
                    x = size.width,
                    y = size.height,
                },
            }
        end
        local segment_data = {}

        local x = 0

        local segments = ugui.internal.parse_rich_text(text)

        -- 1. Compute untranslated (relative to {0,0}) and horizontally stacked rectangles for all segments
        for _, segment in pairs(segments) do
            if segment.type == 'icon' then
                segment_data[#segment_data + 1] = {
                    segment = segment,
                    rectangle = {
                        x = x,
                        y = 0,
                        width = ugui.standard_styler.params.icon_size,
                        height = ugui.standard_styler.params.icon_size,
                    },
                }
                x = x + ugui.standard_styler.params.icon_size
            elseif segment.type == 'text' then
                local size = BreitbandGraphics.get_text_size(segment.value, ugui.standard_styler.params.font_size,
                    ugui.standard_styler.params.font_name)
                segment_data[#segment_data + 1] = {
                    segment = segment,
                    rectangle = {
                        x = x,
                        y = 0,
                        width = size.width,
                        height = size.height,
                    },
                }
                x = x + size.width
            else
                error(string.format("Unknown segment type '%s' encountered in measure_rich_text.", segment.type))
            end
        end

        -- 2. Find out total width and max height
        local total_width = 0
        local max_height = 0
        for _, data in pairs(segment_data) do
            total_width = total_width + data.rectangle.width
            if data.rectangle.height > max_height then
                max_height = data.rectangle.height
            end
        end

        -- 3. Normalize all segments to same max height
        for _, data in pairs(segment_data) do
            data.rectangle.height = max_height
        end

        return {
            segment_data = segment_data,
            size = {
                x = total_width,
                y = max_height,
            },
        }
    end,

    ---Draws rich text with the specified parameters.
    ---@param rectangle Rectangle The rich text's bounds.
    ---@param align_x Alignment? The rich text's horizontal alignment inside the rectangle. If nil, the default is assumed.
    ---@param align_y Alignment? The rich text's vertical alignment inside the rectangle. If nil, the default is assumed.
    ---@param text RichText The rich text.
    ---@param color Color The rich text's color. If a rich text segment contains a color, it is used instead.
    ---@param visual_state VisualState The visual state for rich icons.
    ---@param plaintext boolean? Whether the text is drawn without rich formatting. If nil, false is assumed.
    draw_rich_text = function(rectangle, align_x, align_y, text, color, visual_state, plaintext)
        align_x = align_x or BreitbandGraphics.alignment.center
        align_y = align_y or BreitbandGraphics.alignment.center

        if plaintext then
            BreitbandGraphics.draw_text2({
                text = text,
                rectangle = rectangle,
                color = color,
                align_x = align_x,
                align_y = align_y,
                font_name = ugui.standard_styler.params.font_name,
                font_size = ugui.standard_styler.params.font_size,
                clip = true,
                aliased = not ugui.standard_styler.params.cleartype,
            })
            return
        end

        -- 1. Compute rich text segment data
        local computed = ugui.standard_styler.compute_rich_text(text, plaintext)
        local segment_data = computed.segment_data
        local total_width = computed.size.x

        -- 2. Translate all segments to match the specified alignments
        if align_x == BreitbandGraphics.alignment.start then
            for _, data in pairs(segment_data) do
                data.rectangle.x = data.rectangle.x + rectangle.x
            end
        elseif align_x == BreitbandGraphics.alignment.center then
            local x_offset = rectangle.x + (rectangle.width - total_width) / 2
            for _, data in pairs(segment_data) do
                data.rectangle.x = data.rectangle.x + x_offset
            end
        elseif align_x == BreitbandGraphics.alignment['end'] then
            local x_offset = rectangle.x + rectangle.width - total_width
            for _, data in pairs(segment_data) do
                data.rectangle.x = data.rectangle.x + x_offset
            end
        end

        if align_y == BreitbandGraphics.alignment.start then
            for _, data in pairs(segment_data) do
                data.rectangle.y = data.rectangle.y + rectangle.y
            end
        elseif align_y == BreitbandGraphics.alignment.center then
            for _, data in pairs(segment_data) do
                data.rectangle.y = data.rectangle.y + rectangle.y + rectangle.height / 2 - data.rectangle.height / 2
            end
        elseif align_y == BreitbandGraphics.alignment['end'] then
            for _, data in pairs(segment_data) do
                data.rectangle.y = data.rectangle.y + rectangle.y + rectangle.height - data.rectangle.height
            end
        end

        -- 3. Draw the segments
        for _, data in pairs(segment_data) do
            if data.segment.type == 'icon' then
                ugui.standard_styler.draw_icon(data.rectangle, data.segment.color or color, visual_state,
                    data.segment.value)
            end
            if data.segment.type == 'text' then
                BreitbandGraphics.draw_text2({
                    text = data.segment.value,
                    rectangle = {
                        x = data.rectangle.x,
                        y = data.rectangle.y - 1,
                        width = data.rectangle.width + 1,
                        height = data.rectangle.height + 1,
                    },
                    color = color,
                    align_x = BreitbandGraphics.alignment.start,
                    align_y = BreitbandGraphics.alignment.start,
                    font_name = ugui.standard_styler.params.font_name,
                    font_size = ugui.standard_styler.params.font_size,
                    clip = true,
                    aliased = not ugui.standard_styler.params.cleartype,
                })
            end
        end
    end,

    ---Draws a raised frame with the specified parameters.
    ---@param control Control The control table.
    ---@param visual_state VisualState The control's visual state.
    draw_raised_frame = function(control, visual_state)
        BreitbandGraphics.fill_rectangle(control.rectangle,
            ugui.standard_styler.params.button.border[visual_state])
        BreitbandGraphics.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, -1),
            ugui.standard_styler.params.button.back[visual_state])
    end,

    ---Draws an edit frame with the specified parameters.
    ---@param control Control The control table.
    ---@param visual_state VisualState The control's visual state.
    draw_edit_frame = function(control, rectangle, visual_state)
        BreitbandGraphics.fill_rectangle(control.rectangle,
            ugui.standard_styler.params.textbox.border[visual_state])
        BreitbandGraphics.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, -1),
            ugui.standard_styler.params.textbox.back[visual_state])
    end,

    ---Draws a list frame with the specified parameters.
    ---@param rectangle Rectangle The control bounds.
    ---@param visual_state VisualState The control's visual state.
    draw_list_frame = function(rectangle, visual_state)
        BreitbandGraphics.fill_rectangle(rectangle,
            ugui.standard_styler.params.listbox.border[visual_state])
        BreitbandGraphics.fill_rectangle(BreitbandGraphics.inflate_rectangle(rectangle, -1),
            ugui.standard_styler.params.listbox.back[visual_state])
    end,

    ---Draws a joystick's inner part with the specified parameters.
    ---@param rectangle Rectangle The control bounds.
    ---@param visual_state VisualState The control's visual state.
    ---@param position Vector2 The joystick's position.
    draw_joystick_inner = function(rectangle, visual_state, position)
        local back_color = ugui.standard_styler.params.joystick.back[visual_state]
        local outline_color = ugui.standard_styler.params.joystick.outline[visual_state]
        local tip_color = ugui.standard_styler.params.joystick.tip[visual_state]
        local line_color = ugui.standard_styler.params.joystick.line[visual_state]
        local inner_mag_color = ugui.standard_styler.params.joystick.inner_mag[visual_state]
        local outer_mag_color = ugui.standard_styler.params.joystick.outer_mag[visual_state]
        local mag_thickness = ugui.standard_styler.params.joystick.mag_thicknesses[visual_state]

        BreitbandGraphics.fill_ellipse(BreitbandGraphics.inflate_rectangle(rectangle, -1),
            back_color)
        BreitbandGraphics.draw_ellipse(BreitbandGraphics.inflate_rectangle(rectangle, -1),
            outline_color, 1)
        BreitbandGraphics.draw_line({
            x = rectangle.x + rectangle.width / 2,
            y = rectangle.y,
        }, {
            x = rectangle.x + rectangle.width / 2,
            y = rectangle.y + rectangle.height,
        }, outline_color, 1)
        BreitbandGraphics.draw_line({
            x = rectangle.x,
            y = rectangle.y + rectangle.height / 2,
        }, {
            x = rectangle.x + rectangle.width,
            y = rectangle.y + rectangle.height / 2,
        }, outline_color, 1)


        local r = position.r - mag_thickness
        if r > 0 then
            BreitbandGraphics.fill_ellipse({
                x = rectangle.x + rectangle.width / 2 - r / 2,
                y = rectangle.y + rectangle.height / 2 - r / 2,
                width = r,
                height = r,
            }, inner_mag_color)
            r = position.r

            BreitbandGraphics.draw_ellipse({
                x = rectangle.x + rectangle.width / 2 - r / 2,
                y = rectangle.y + rectangle.height / 2 - r / 2,
                width = r,
                height = r,
            }, outer_mag_color, mag_thickness)
        end


        BreitbandGraphics.draw_line({
            x = rectangle.x + rectangle.width / 2,
            y = rectangle.y + rectangle.height / 2,
        }, {
            x = position.x,
            y = position.y,
        }, line_color, 3)

        BreitbandGraphics.fill_ellipse({
            x = position.x - ugui.standard_styler.params.joystick.tip_size / 2,
            y = position.y - ugui.standard_styler.params.joystick.tip_size / 2,
            width = ugui.standard_styler.params.joystick.tip_size,
            height = ugui.standard_styler.params.joystick.tip_size,
        }, tip_color)
    end,

    ---Draws a scrollbar with the specified parameters.
    ---@param control ScrollBar
    ---@param thumb_rectangle Rectangle The scrollbar thumb's bounds.
    draw_scrollbar = function(control, thumb_rectangle)
        local visual_state = ugui.get_visual_state(control)
        BreitbandGraphics.fill_rectangle(control.rectangle,
            ugui.standard_styler.params.scrollbar.back[visual_state])
        BreitbandGraphics.fill_rectangle(thumb_rectangle,
            ugui.standard_styler.params.scrollbar.thumb[visual_state])
    end,

    ---Draws a list item with the specified parameters.
    ---@param control Control The associated list control.
    ---@param item string The list item's text.
    ---@param rectangle Rectangle The list item's bounds.
    ---@param visual_state VisualState The control's visual state.
    draw_list_item = function(control, item, rectangle, visual_state)
        if not item then
            return
        end
        BreitbandGraphics.fill_rectangle(rectangle,
            ugui.standard_styler.params.listbox_item.back[visual_state])

        local size = BreitbandGraphics.get_text_size(item, ugui.standard_styler.params.font_size,
            ugui.standard_styler.params.font_name)

        local text_rect = {
            x = rectangle.x + 2,
            y = rectangle.y,
            width = size.width * 2,
            height = rectangle.height,
        }

        ugui.standard_styler.draw_rich_text(text_rect, BreitbandGraphics.alignment.start, nil, item,
            ugui.standard_styler.params.listbox_item.text[visual_state], visual_state, control.plaintext)
    end,

    ---Draws a list with the specified parameters.
    ---@param control ListBox The control table.
    ---@param rectangle Rectangle The list item's bounds.
    draw_list = function(control, rectangle)
        local visual_state = ugui.get_visual_state(control)
        local data = ugui.internal.control_data[control.uid]

        ugui.standard_styler.draw_list_frame(rectangle, visual_state)

        local content_bounds = ugui.standard_styler.get_desired_listbox_content_bounds(control)
        -- item y position:
        -- y = (20 * (i - 1)) - (scroll_y * ((20 * #control.items) - control.rectangle.height))
        local scroll_x = data.scroll_x and data.scroll_x or 0
        local scroll_y = data.scroll_y and data.scroll_y or 0

        local index_begin = (scroll_y *
                (content_bounds.height - rectangle.height)) /
            ugui.standard_styler.params.listbox_item.height

        local index_end = (rectangle.height + (scroll_y *
                (content_bounds.height - rectangle.height))) /
            ugui.standard_styler.params.listbox_item.height

        index_begin = ugui.internal.clamp(math.floor(index_begin), 1, #control.items)
        index_end = ugui.internal.clamp(math.ceil(index_end), 1, #control.items)

        local x_offset = math.max((content_bounds.width - control.rectangle.width) * scroll_x, 0)

        BreitbandGraphics.push_clip(BreitbandGraphics.inflate_rectangle(rectangle, -1))

        for i = index_begin, index_end, 1 do
            local y_offset = (ugui.standard_styler.params.listbox_item.height * (i - 1)) -
                (scroll_y * (content_bounds.height - rectangle.height))

            local item_visual_state = ugui.visual_states.normal
            if control.is_enabled == false then
                item_visual_state = ugui.visual_states.disabled
            end

            if data.selected_index == i then
                item_visual_state = ugui.visual_states.active
            end

            ugui.standard_styler.draw_list_item(control, control.items[i], {
                x = rectangle.x - x_offset,
                y = rectangle.y + y_offset,
                width = math.max(content_bounds.width, control.rectangle.width),
                height = ugui.standard_styler.params.listbox_item.height,
            }, item_visual_state)
        end

        BreitbandGraphics.pop_clip()
    end,

    ---Draws a menu frame with the specified parameters.
    ---@param rectangle Rectangle The control's bounds.
    ---@param visual_state VisualState The control's visual state.
    draw_menu_frame = function(rectangle, visual_state)
        BreitbandGraphics.fill_rectangle(rectangle,
            ugui.standard_styler.params.menu.border[visual_state])
        BreitbandGraphics.fill_rectangle(BreitbandGraphics.inflate_rectangle(rectangle, -1),
            ugui.standard_styler.params.menu.back[visual_state])
    end,

    ---Draws a menu item with the specified parameters.
    ---@param item MenuItem The menu item.
    ---@param rectangle Rectangle The control's bounds.
    ---@param visual_state VisualState The control's visual state.
    draw_menu_item = function(item, rectangle, visual_state)
        BreitbandGraphics.fill_rectangle(rectangle,
            ugui.standard_styler.params.menu_item.back[visual_state])
        BreitbandGraphics.push_clip({
            x = rectangle.x,
            y = rectangle.y,
            width = rectangle.width,
            height = rectangle.height,
        })

        if item.checked then
            local icon_rect = BreitbandGraphics.inflate_rectangle({
                x = rectangle.x + (ugui.standard_styler.params.menu_item.left_padding - rectangle.height) * 0.5,
                y = rectangle.y,
                width = rectangle.height,
                height = rectangle.height,
            }, -7)
            ugui.standard_styler.draw_icon(icon_rect, ugui.standard_styler.params.menu_item.height, nil, 'checkmark')
        end

        if item.items then
            local icon_rect = BreitbandGraphics.inflate_rectangle({
                x = rectangle.x + rectangle.width - (ugui.standard_styler.params.menu_item.right_padding),
                y = rectangle.y,
                width = ugui.standard_styler.params.menu_item.right_padding,
                height = rectangle.height,
            }, -7)
            ugui.standard_styler.draw_icon(icon_rect, ugui.standard_styler.params.menu_item.height, nil, 'arrow_right')
        end

        local text_rect = {
            x = rectangle.x + ugui.standard_styler.params.menu_item.left_padding,
            y = rectangle.y,
            width = 9999999,
            height = rectangle.height,
        }

        BreitbandGraphics.draw_text2({
            text = item.text,
            rectangle = text_rect,
            color = ugui.standard_styler.params.menu_item.text[visual_state],
            align_x = BreitbandGraphics.alignment.start,
            font_name = ugui.standard_styler.params.font_name,
            font_size = ugui.standard_styler.params.font_size,
            aliased = not ugui.standard_styler.params.cleartype,
        })

        BreitbandGraphics.pop_clip()
    end,

    ---Draws a menu with the specified parameters.
    ---@param control Menu The menu control.
    ---@param rectangle Rectangle The control's bounds.
    draw_menu = function(control, rectangle)
        local visual_state = ugui.get_visual_state(control)
        ugui.standard_styler.draw_menu_frame(rectangle, visual_state)

        local y = rectangle.y

        for i, item in pairs(control.items) do
            local rectangle = BreitbandGraphics.inflate_rectangle({
                x = rectangle.x,
                y = y,
                width = rectangle.width,
                height = ugui.standard_styler.params.menu_item.height,
            }, -1)

            local visual_state = ugui.visual_states.normal
            if ugui.internal.control_data[control.uid].hovered_index and ugui.internal.control_data[control.uid].hovered_index == i then
                visual_state = ugui.visual_states.hovered
            end
            if item.enabled == false then
                visual_state = ugui.visual_states.disabled
            end
            ugui.standard_styler.draw_menu_item(item, rectangle, visual_state)

            y = y + ugui.standard_styler.params.menu_item.height
        end
    end,

    ---Draws a tooltip with the specified parameters.
    ---@param control Control The tooltip's parent control.
    ---@param position Vector2 The tooltip's position.
    draw_tooltip = function(control, position)
        local text = control.tooltip
        if not text then
            return
        end
        local rectangle = { x = position.x, y = position.y, width = 0, height = 0 }
        local size = ugui.standard_styler.compute_rich_text(text, control.plaintext).size

        rectangle.width = size.x
        rectangle.height = math.max(size.y, ugui.standard_styler.params.menu_item.height)
        rectangle.y = rectangle.y + rectangle.height

        if rectangle.x + rectangle.width > ugui.internal.environment.window_size.x then
            rectangle.x = rectangle.x - (rectangle.x + rectangle.width - ugui.internal.environment.window_size.x)
        end
        if rectangle.y + rectangle.height > ugui.internal.environment.window_size.y then
            rectangle.y = rectangle.y - (rectangle.y + rectangle.height - ugui.internal.environment.window_size.y)
        end

        rectangle.x = math.max(rectangle.x, 0)
        rectangle.y = math.max(rectangle.y, 0)

        local fit = false

        if rectangle.width >= ugui.internal.environment.window_size.x then
            fit = true
            rectangle.x = 0
            rectangle.width = ugui.internal.environment.window_size.x
        end

        if rectangle.height >= ugui.internal.environment.window_size.y then
            fit = true
            rectangle.y = 0
            rectangle.height = ugui.internal.environment.window_size.y
        end

        local menu_frame_rect = fit and rectangle or {
            x = rectangle.x - ugui.standard_styler.params.tooltip.padding,
            y = rectangle.y,
            width = rectangle.width + ugui.standard_styler.params.tooltip.padding * 2,
            height = rectangle.height,
        }
        ugui.standard_styler.draw_menu_frame(menu_frame_rect, ugui.visual_states.normal)

        if not fit then
            rectangle.width = 99999
        end

        ugui.standard_styler.draw_rich_text(rectangle, BreitbandGraphics.alignment.start, nil, text,
            ugui.standard_styler.params.menu_item.text[ugui.visual_states.normal], ugui.visual_states.normal,
            control.plaintext)
    end,

    ---Draws a Button with the specified parameters.
    ---@param control Button The control table.
    draw_button = function(control)
        local visual_state = ugui.get_visual_state(control)

        -- NOTE: Avoids duplicating code for ToggleButton in this implementation by putting it here
        ---@diagnostic disable-next-line: undefined-field
        if control.is_checked and control.is_enabled ~= false then
            visual_state = ugui.visual_states.active
        end

        ugui.standard_styler.draw_raised_frame(control, visual_state)
        ugui.standard_styler.draw_rich_text(control.rectangle, nil, nil, control.text,
            ugui.standard_styler.params.button.text[visual_state], visual_state, control.plaintext)
    end,

    ---Draws a ToggleButton with the specified parameters.
    ---@param control ToggleButton The control table.
    draw_togglebutton = function(control)
        ugui.standard_styler.draw_button(control)
    end,

    ---Draws a CarrouselButton with the specified parameters.
    ---@param control CarrouselButton The control table.
    draw_carrousel_button = function(control)
        -- add a "fake" text field
        local copy = ugui.internal.deep_clone(control)
        copy.text = control.items and control.items[control.selected_index] or ''
        ugui.standard_styler.draw_button(copy)

        local visual_state = ugui.get_visual_state(control)

        -- draw the arrows
        ugui.standard_styler.draw_icon({
            x = control.rectangle.x + ugui.standard_styler.params.textbox.padding.x,
            y = control.rectangle.y,
            width = ugui.standard_styler.params.icon_size,
            height = control.rectangle.height,
        }, ugui.standard_styler.params.button.text[visual_state], visual_state, 'arrow_left')
        ugui.standard_styler.draw_icon({
            x = control.rectangle.x + control.rectangle.width - ugui.standard_styler.params.textbox.padding.x -
                ugui.standard_styler.params.icon_size,
            y = control.rectangle.y,
            width = ugui.standard_styler.params.icon_size,
            height = control.rectangle.height,
        }, ugui.standard_styler.params.button.text[visual_state], visual_state, 'arrow_right')
    end,

    ---Draws a TextBox with the specified parameters.
    ---@param control TextBox The control table.
    draw_textbox = function(control)
        local data = ugui.internal.control_data[control.uid]
        local visual_state = ugui.get_visual_state(control)
        local text = control.text or ''

        -- Special case: if we're capturing the keyboard, we consider ourselves "active"
        if ugui.internal.keyboard_captured_control == control.uid then
            visual_state = ugui.visual_states.active
        end

        ugui.standard_styler.draw_edit_frame(control, control.rectangle, visual_state)

        local should_visualize_selection =
            control.is_enabled ~= false
            and data.selection_start ~= data.selection_end
            and ugui.internal.keyboard_captured_control == control.uid

        if should_visualize_selection then
            local string_to_selection_start = text:sub(1,
                data.selection_start - 1)
            local string_to_selection_end = text:sub(1,
                data.selection_end - 1)

            BreitbandGraphics.fill_rectangle({
                    x = control.rectangle.x +
                        BreitbandGraphics.get_text_size(string_to_selection_start,
                            ugui.standard_styler.params.font_size,
                            ugui.standard_styler.params.font_name)
                        .width + ugui.standard_styler.params.textbox.padding.x,
                    y = control.rectangle.y,
                    width = BreitbandGraphics.get_text_size(string_to_selection_end,
                            ugui.standard_styler.params.font_size,
                            ugui.standard_styler.params.font_name)
                        .width -
                        BreitbandGraphics.get_text_size(string_to_selection_start,
                            ugui.standard_styler.params.font_size,
                            ugui.standard_styler.params.font_name)
                        .width,
                    height = control.rectangle.height,
                },
                ugui.standard_styler.params.textbox.selection)
        end

        local text_rect = {
            x = control.rectangle.x + ugui.standard_styler.params.textbox.padding.x,
            y = control.rectangle.y,
            width = control.rectangle.width - ugui.standard_styler.params.textbox.padding.x * 2,
            height = control.rectangle.height,
        }

        BreitbandGraphics.draw_text2({
            text = text,
            rectangle = text_rect,
            color = ugui.standard_styler.params.textbox.text[visual_state],
            align_x = BreitbandGraphics.alignment.start,
            align_y = BreitbandGraphics.alignment.start,
            font_name = ugui.standard_styler.params.font_name,
            font_size = ugui.standard_styler.params.font_size,
            clip = true,
            aliased = not ugui.standard_styler.params.cleartype,
        })

        if should_visualize_selection then
            local lower = data.selection_start
            local higher = data.selection_end
            if data.selection_start > data.selection_end then
                lower = data.selection_end
                higher = data.selection_start
            end

            local string_to_selection_start = text:sub(1,
                lower - 1)
            local string_to_selection_end = text:sub(1,
                higher - 1)

            local selection_start_x = control.rectangle.x +
                BreitbandGraphics.get_text_size(string_to_selection_start,
                    ugui.standard_styler.params.font_size,
                    ugui.standard_styler.params.font_name).width +
                ugui.standard_styler.params.textbox.padding.x

            local selection_end_x = control.rectangle.x +
                BreitbandGraphics.get_text_size(string_to_selection_end,
                    ugui.standard_styler.params.font_size,
                    ugui.standard_styler.params.font_name).width +
                ugui.standard_styler.params.textbox.padding.x

            BreitbandGraphics.push_clip({
                x = selection_start_x,
                y = control.rectangle.y,
                width = selection_end_x - selection_start_x,
                height = control.rectangle.height,
            })

            local text_rect = {
                x = control.rectangle.x + ugui.standard_styler.params.textbox.padding.x,
                y = control.rectangle.y,
                width = control.rectangle.width - ugui.standard_styler.params.textbox.padding.x * 2,
                height = control.rectangle.height,
            }

            BreitbandGraphics.draw_text2({
                text = text,
                rectangle = text_rect,
                color = BreitbandGraphics.invert_color(ugui.standard_styler.params.textbox.text[visual_state]),
                align_x = BreitbandGraphics.alignment.start,
                align_y = BreitbandGraphics.alignment.start,
                font_name = ugui.standard_styler.params.font_name,
                font_size = ugui.standard_styler.params.font_size,
                clip = true,
                aliased = not ugui.standard_styler.params.cleartype,
            })

            BreitbandGraphics.pop_clip()
        end


        local string_to_caret = text:sub(1, data.caret_index - 1)
        local caret_x = BreitbandGraphics.get_text_size(string_to_caret,
                ugui.standard_styler.params.font_size,
                ugui.standard_styler.params.font_name).width +
            ugui.standard_styler.params.textbox.padding.x

        if visual_state == ugui.visual_states.active and math.floor(os.clock() * 2) % 2 == 0 and not should_visualize_selection then
            BreitbandGraphics.draw_line({
                x = control.rectangle.x + caret_x,
                y = control.rectangle.y + 2,
            }, {
                x = control.rectangle.x + caret_x,
                y = control.rectangle.y +
                    math.max(15,
                        BreitbandGraphics.get_text_size(string_to_caret, 12,
                            ugui.standard_styler.params.font_name)
                        .height), -- TODO: move text measurement into BreitbandGraphics
            }, {
                r = 0,
                g = 0,
                b = 0,
            }, 1)
        end
    end,

    ---Draws a Joystick with the specified parameters.
    ---@param control Joystick The control table.
    draw_joystick = function(control)
        local visual_state = ugui.get_visual_state(control)
        local x = control.position and control.position.x or 0
        local y = control.position and control.position.y or 0
        local mag = control.mag or 0

        -- joystick has no hover or active states
        if not (visual_state == ugui.visual_states.disabled) then
            visual_state = ugui.visual_states.normal
        end

        ugui.standard_styler.draw_raised_frame(control, visual_state)
        ugui.standard_styler.draw_joystick_inner(control.rectangle, visual_state, {
            x = ugui.internal.remap(ugui.internal.clamp(x, -128, 128), -128, 128,
                control.rectangle.x, control.rectangle.x + control.rectangle.width),
            y = ugui.internal.remap(ugui.internal.clamp(y, -128, 128), -128, 128,
                control.rectangle.y, control.rectangle.y + control.rectangle.height),
            r = ugui.internal.remap(ugui.internal.clamp(mag, 0, 128), 0, 128, 0,
                math.min(control.rectangle.width, control.rectangle.height)),
        })
    end,
    draw_track = function(control, visual_state, is_horizontal)
        local track_rectangle = {}
        if not is_horizontal then
            track_rectangle = {
                x = control.rectangle.x + control.rectangle.width / 2 -
                    ugui.standard_styler.params.trackbar.track_thickness / 2,
                y = control.rectangle.y,
                width = ugui.standard_styler.params.trackbar.track_thickness,
                height = control.rectangle.height,
            }
        else
            track_rectangle = {
                x = control.rectangle.x,
                y = control.rectangle.y + control.rectangle.height / 2 -
                    ugui.standard_styler.params.trackbar.track_thickness / 2,
                width = control.rectangle.width,
                height = ugui.standard_styler.params.trackbar.track_thickness,
            }
        end

        BreitbandGraphics.fill_rectangle(BreitbandGraphics.inflate_rectangle(track_rectangle, 1),
            ugui.standard_styler.params.trackbar.border[visual_state])
        BreitbandGraphics.fill_rectangle(track_rectangle,
            ugui.standard_styler.params.trackbar.back[visual_state])
    end,

    ---Draws a Trackbar's thumb with the specified parameters.
    ---@param control Trackbar The control table.
    ---@param visual_state VisualState The control's visual state.
    ---@param is_horizontal boolean Whether the trackbar is horizontal.
    ---@param value number The trackbar's value.
    draw_thumb = function(control, visual_state, is_horizontal, value)
        local head_rectangle = {}
        local effective_bar_height = math.min(
            (is_horizontal and control.rectangle.height or control.rectangle.width) * 2,
            ugui.standard_styler.params.trackbar.bar_height)
        if not is_horizontal then
            head_rectangle = {
                x = control.rectangle.x + control.rectangle.width / 2 -
                    effective_bar_height / 2,
                y = control.rectangle.y + (value * control.rectangle.height) -
                    ugui.standard_styler.params.trackbar.bar_width / 2,
                width = effective_bar_height,
                height = ugui.standard_styler.params.trackbar.bar_width,
            }
        else
            head_rectangle = {
                x = control.rectangle.x + (value * control.rectangle.width) -
                    ugui.standard_styler.params.trackbar.bar_width / 2,
                y = control.rectangle.y + control.rectangle.height / 2 -
                    effective_bar_height / 2,
                width = ugui.standard_styler.params.trackbar.bar_width,
                height = effective_bar_height,
            }
        end
        BreitbandGraphics.fill_rectangle(head_rectangle,
            ugui.standard_styler.params.trackbar.thumb[visual_state])
    end,

    ---Draws a Trackbar with the specified parameters.
    ---@param control Trackbar The control table.
    draw_trackbar = function(control)
        local visual_state = ugui.get_visual_state(control)
        local data = ugui.internal.control_data[control.uid]

        if ugui.internal.mouse_captured_control == control.uid and control.is_enabled ~= false then
            visual_state = ugui.visual_states.active
        end

        local is_horizontal = control.rectangle.width > control.rectangle.height

        ugui.standard_styler.draw_track(control, visual_state, is_horizontal)
        ugui.standard_styler.draw_thumb(control, visual_state, is_horizontal, data.value)
    end,

    ---Draws a ComboBox with the specified parameters.
    ---@param control ComboBox The control table.
    draw_combobox = function(control)
        local visual_state = ugui.get_visual_state(control)
        local data = ugui.internal.control_data[control.uid]
        local selected_item = data.selected_index == nil and '' or control.items[data.selected_index]

        if data.open and control.is_enabled ~= false then
            visual_state = ugui.visual_states.active
        end

        ugui.standard_styler.draw_raised_frame(control, visual_state)

        local text_color = ugui.standard_styler.params.button.text[visual_state]

        local text_rect = {
            x = control.rectangle.x + ugui.standard_styler.params.textbox.padding.x * 2,
            y = control.rectangle.y,
            width = control.rectangle.width,
            height = control.rectangle.height,
        }

        ugui.standard_styler.draw_rich_text(text_rect, BreitbandGraphics.alignment.start, nil, selected_item, text_color,
            visual_state, control.plaintext)
        ugui.standard_styler.draw_icon({
            x = control.rectangle.x + control.rectangle.width - ugui.standard_styler.params.icon_size -
                ugui.standard_styler.params.textbox.padding.x * 2,
            y = control.rectangle.y,
            width = ugui.standard_styler.params.icon_size,
            height = control.rectangle.height,
        }, text_color, visual_state, 'arrow_down')
    end,

    ---Draws a ListBox with the specified parameters.
    ---@param control ListBox The control table.
    draw_listbox = function(control)
        ugui.standard_styler.draw_list(control, control.rectangle)
    end,

    ---Gets the desired bounds of a listbox's content.
    ---@param control table A table abiding by the mupen-lua-ugui control contract
    ---@return _ table A rectangle specifying the desired bounds of the content as `{x = 0, y = 0, width: number, height: number}`.
    get_desired_listbox_content_bounds = function(control)
        -- Since horizontal content bounds measuring is expensive, we only do this if explicitly enabled.
        local max_width = 0
        if control.horizontal_scroll == true then
            for _, value in pairs(control.items) do
                local width = BreitbandGraphics.get_text_size(value, ugui.standard_styler.params.font_size,
                    ugui.standard_styler.params.font_name).width

                if width > max_width then
                    max_width = width
                end
            end
        end

        return {
            x = 0,
            y = 0,
            width = max_width,
            height = ugui.standard_styler.params.listbox_item.height * (control.items and #control.items or 0),
        }
    end,
}
