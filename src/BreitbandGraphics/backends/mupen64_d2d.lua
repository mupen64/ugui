if d2d and d2d.create_render_target then
    error('BreitbandGraphics: mupen64-rr-lua 1.1.7 or newer is required to use BreitbandGraphics.')
end

---Gets a brush from a color value, creating one and caching it if it doesn't already exist in the cache.
---@param color ColorSource The color value to create a brush from.
---@return integer # The brush handle.
BreitbandGraphics.internal.brush_from_color = function(color)
    local float = BreitbandGraphics.internal.color_source_to_float_color(color)
    local converted = BreitbandGraphics.float_to_color(float)
    local key = (converted.r << 24) | (converted.g << 16) | (converted.b << 8) | (converted.a and converted.a or 255)
    if not BreitbandGraphics.internal.brushes[key] then
        BreitbandGraphics.internal.brushes[key] = d2d.create_brush(float.r, float.g, float.b, float.a)
    end
    return BreitbandGraphics.internal.brushes[key]
end

---Gets an image from a path, creating one and caching it if it doesn't already exist in the cache.
---@param path string The path to the image.
---@return integer # The image handle.
BreitbandGraphics.internal.image_from_path = function(path)
    if not BreitbandGraphics.internal.images[path] then
        BreitbandGraphics.internal.images[path] = d2d.load_image(path)
    end
    return BreitbandGraphics.internal.images[path]
end

---Computes the bounding box of a text string given a font size and font name.
---@param text string The string to be measured.
---@param font_size number The font size.
---@param font_name string The font name.
---@return Size # The text's bounding box.
BreitbandGraphics.get_text_size = function(text, font_size, font_name)
    return d2d.get_text_size(text, font_name, font_size, 99999999, 99999999)
end

---Draws a rectangle's outline.
---@param rectangle Rectangle The shape's bounding rectangle.
---@param color ColorSource The outline's color.
---@param thickness number The outline's thickness.
BreitbandGraphics.draw_rectangle = function(rectangle, color, thickness)
    local brush = BreitbandGraphics.internal.brush_from_color(color)
    d2d.draw_rectangle(
        rectangle.x,
        rectangle.y,
        rectangle.x + rectangle.width,
        rectangle.y + rectangle.height,
        thickness,
        brush)
end

---Draws a filled-in rectangle.
---@param rectangle Rectangle The shape's bounding rectangle.
---@param color ColorSource The fill color.
BreitbandGraphics.fill_rectangle = function(rectangle, color)
    local brush = BreitbandGraphics.internal.brush_from_color(color)
    d2d.fill_rectangle(
        rectangle.x,
        rectangle.y,
        rectangle.x + rectangle.width,
        rectangle.y + rectangle.height,
        brush)
end

---Draws a rounded rectangle's outline.
---@param rectangle Rectangle The shape's bounding rectangle.
---@param color ColorSource The outline's color.
---@param radii Vector2 The corner radii.
---@param thickness number The outline's thickness.
BreitbandGraphics.draw_rounded_rectangle = function(rectangle, color, radii, thickness)
    local brush = BreitbandGraphics.internal.brush_from_color(color)
    d2d.draw_rounded_rectangle(
        rectangle.x,
        rectangle.y,
        rectangle.x + rectangle.width,
        rectangle.y + rectangle.height,
        radii.x,
        radii.y,
        thickness,
        brush)
end

---Draws a filled-in rounded rectangle.
---@param rectangle Rectangle The shape's bounding rectangle.
---@param color ColorSource The fill color.
---@param radii Vector2 The corner radii.
BreitbandGraphics.fill_rounded_rectangle = function(rectangle, color, radii)
    local brush = BreitbandGraphics.internal.brush_from_color(color)
    d2d.fill_rounded_rectangle(
        rectangle.x,
        rectangle.y,
        rectangle.x + rectangle.width,
        rectangle.y + rectangle.height,
        radii.x,
        radii.y,
        brush)
end

---Draws an ellipse's outline.
---@param rectangle Rectangle The shape's bounding rectangle.
---@param color ColorSource The outline's color.
---@param thickness number The outline's thickness.
BreitbandGraphics.draw_ellipse = function(rectangle, color, thickness)
    local brush = BreitbandGraphics.internal.brush_from_color(color)
    d2d.draw_ellipse(
        rectangle.x + rectangle.width / 2,
        rectangle.y + rectangle.height / 2,
        rectangle.width / 2,
        rectangle.height / 2,
        thickness,
        brush)
end

---Draws a filled-in ellipse.
---@param rectangle Rectangle The shape's bounding rectangle.
---@param color ColorSource The fill color.
BreitbandGraphics.fill_ellipse = function(rectangle, color)
    local brush = BreitbandGraphics.internal.brush_from_color(color)
    d2d.fill_ellipse(
        rectangle.x + rectangle.width / 2,
        rectangle.y + rectangle.height / 2,
        rectangle.width / 2,
        rectangle.height / 2,
        brush)
end

---Draws text with the specified parameters.
---Deprecated, use `draw_text2` instead.
---@param rectangle Rectangle The text's bounding rectangle.
---@param horizontal_alignment "center"|"start"|"end"|"stretch" The text's horizontal alignment inside the bounding rectangle.
---@param vertical_alignment "center"|"start"|"end"|"stretch" The text's vertical alignment inside the bounding rectangle.
---@param style TextStyle The text style options.
---@param color ColorSource The text color.
---@param font_size number The font size.
---@param font_name string The font name.
---@param text string The text.
---@deprecated
BreitbandGraphics.draw_text = function(rectangle, horizontal_alignment, vertical_alignment, style, color, font_size,
                                       font_name,
                                       text)
    if text == nil then
        text = ''
    end

    local rect_x = rectangle.x
    local rect_y = rectangle.y
    local rect_w = rectangle.width
    local rect_h = rectangle.height
    local brush = BreitbandGraphics.internal.brush_from_color(color)
    local d_horizontal_alignment = 0
    local d_vertical_alignment = 0
    local d_style = 0
    local d_weight = 400
    local d_options = 0
    local d_text_antialias_mode = 1

    if horizontal_alignment == 'center' then
        d_horizontal_alignment = 2
    elseif horizontal_alignment == 'start' then
        d_horizontal_alignment = 0
    elseif horizontal_alignment == 'end' then
        d_horizontal_alignment = 1
    elseif horizontal_alignment == 'stretch' then
        d_horizontal_alignment = 3
    end

    if vertical_alignment == 'center' then
        d_vertical_alignment = 2
    elseif vertical_alignment == 'start' then
        d_vertical_alignment = 0
    elseif vertical_alignment == 'end' then
        d_vertical_alignment = 1
    end

    if style.is_bold then
        d_weight = 700
    end
    if style.is_italic then
        d_style = 2
    end
    if style.clip then
        d_options = d_options | 0x00000002
    end
    if style.grayscale then
        d_text_antialias_mode = 2
    end
    if style.aliased then
        d_text_antialias_mode = 3
    end
    if style.fit then
        -- Try to fit the text into the specified rectangle by reducing the font size
        local text_size = d2d.get_text_size(text, font_name, font_size, math.maxinteger, math.maxinteger)

        if text_size.width > rectangle.width then
            font_size = font_size / math.max(0.01, (text_size.width / rectangle.width))
        end
        if text_size.height > rectangle.height then
            font_size = font_size / math.max(0.01, (text_size.height / rectangle.height))
        end

        local text_size = d2d.get_text_size(text, font_name, font_size, math.maxinteger, math.maxinteger)

        -- Since the rect stays the same, the text will want to wrap.
        -- We solve that by recomputing the rect and alignments
        if horizontal_alignment == 'center' or horizontal_alignment == 'stretch' then
            rect_x = rect_x + rect_w / 2 - text_size.width / 2
        elseif horizontal_alignment == 'start' then
            rect_x = rect_x
        elseif horizontal_alignment == 'end' then
            rect_x = rect_x + rect_w - text_size.width
        end

        if vertical_alignment == 'center' or vertical_alignment == 'stretch' then
            rect_y = rect_y + rect_h / 2 - text_size.height / 2
        elseif vertical_alignment == 'start' then
            rect_y = rect_y
        elseif vertical_alignment == 'end' then
            rect_y = rect_y + rect_h - text_size.height
        end

        d_horizontal_alignment = 0
        d_vertical_alignment = 0

        rect_w = text_size.width + 1
        rect_h = text_size.height + 1
    end
    if type(text) ~= 'string' then
        text = tostring(text)
    end
    d2d.set_text_antialias_mode(d_text_antialias_mode)
    d2d.draw_text(
        rect_x,
        rect_y,
        rect_x + rect_w,
        rect_y + rect_h,
        text,
        font_name,
        font_size,
        d_weight,
        d_style,
        d_horizontal_alignment,
        d_vertical_alignment,
        d_options,
        brush)
end

---Draws text with the specified parameters.
---@param params DrawTextParams The text drawing parameters.
BreitbandGraphics.draw_text2 = function(params)
    if not params.text then
        return
    end

    local internal_alignment_to_d2d_alignment_map = {
        [BreitbandGraphics.alignment.start] = 0,
        [BreitbandGraphics.alignment.center] = 2,
        [BreitbandGraphics.alignment['end']] = 1,
        [BreitbandGraphics.alignment.stretch] = 3,
    }

    local rect_x = params.rectangle.x
    local rect_y = params.rectangle.y
    local rect_w = params.rectangle.width
    local rect_h = params.rectangle.height
    local brush = BreitbandGraphics.internal.brush_from_color(params.color)
    local d_horizontal_alignment = params.align_x and internal_alignment_to_d2d_alignment_map[params.align_x] or
        internal_alignment_to_d2d_alignment_map[BreitbandGraphics.alignment.center]
    local d_vertical_alignment = params.align_y and internal_alignment_to_d2d_alignment_map[params.align_y] or
        internal_alignment_to_d2d_alignment_map[BreitbandGraphics.alignment.center]
    local d_style = 0
    local d_weight = 400
    local d_options = 0
    local d_text_antialias_mode = 1
    local font_size = params.font_size

    if params.is_bold then
        d_weight = 700
    end
    if params.is_italic then
        d_style = 2
    end
    if params.clip then
        d_options = d_options | 0x00000002
    end
    if params.grayscale then
        d_text_antialias_mode = 2
    end
    if params.aliased then
        d_text_antialias_mode = 3
    end
    if params.fit then
        -- Try to fit the text into the specified rectangle by reducing the font size
        local text_size = d2d.get_text_size(params.text, params.font_name, params.font_size, math.maxinteger,
            math.maxinteger)

        if text_size.width > params.rectangle.width then
            font_size = font_size / math.max(0.01, (text_size.width / params.rectangle.width))
        end
        if text_size.height > params.rectangle.height then
            font_size = font_size / math.max(0.01, (text_size.height / params.rectangle.height))
        end

        local text_size = d2d.get_text_size(params.text, params.font_name, font_size, math.maxinteger, math.maxinteger)

        -- Since the rect stays the same, the text will want to wrap.
        -- We solve that by recomputing the rect and alignments
        if params.align_x == BreitbandGraphics.alignment.center or params.align_x == BreitbandGraphics.alignment.stretch then
            rect_x = rect_x + rect_w / 2 - text_size.width / 2
        elseif params.align_x == BreitbandGraphics.alignment.start then
            rect_x = rect_x
        elseif params.align_x == BreitbandGraphics.alignment['end'] then
            rect_x = rect_x + rect_w - text_size.width
        end

        if params.align_y == BreitbandGraphics.alignment.center or params.align_y == BreitbandGraphics.alignment.stretch then
            rect_y = rect_y + rect_h / 2 - text_size.height / 2
        elseif params.align_y == BreitbandGraphics.alignment.start then
            rect_y = rect_y
        elseif params.align_y == BreitbandGraphics.alignment['end'] then
            rect_y = rect_y + rect_h - text_size.height
        end

        d_horizontal_alignment = 0
        d_vertical_alignment = 0

        rect_w = text_size.width + 1
        rect_h = text_size.height + 1
    end


    d2d.set_text_antialias_mode(d_text_antialias_mode)
    d2d.draw_text(
        rect_x,
        rect_y,
        rect_x + rect_w,
        rect_y + rect_h,
        params.text,
        params.font_name,
        font_size,
        d_weight,
        d_style,
        d_horizontal_alignment,
        d_vertical_alignment,
        d_options,
        brush)
end

---Draws a line between two points.
---@param from Vector2 The start point.
---@param to Vector2 The end point.
---@param color ColorSource The line's color.
---@param thickness number The line's thickness.
BreitbandGraphics.draw_line = function(from, to, color, thickness)
    local brush = BreitbandGraphics.internal.brush_from_color(color)

    d2d.draw_line(
        from.x,
        from.y,
        to.x,
        to.y,
        thickness,
        brush)
end

---Pushes a clip layer to the clip stack.
---@param rectangle Rectangle The clip bounds.
BreitbandGraphics.push_clip = function(rectangle)
    d2d.push_clip(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
        rectangle.y + rectangle.height)
end

--- Removes the topmost clip layer from the clip stack.
BreitbandGraphics.pop_clip = function()
    d2d.pop_clip()
end

---Draws an image with the specified parameters.
---@param destination_rectangle Rectangle The destination rectangle on the screen.
---@param source_rectangle Rectangle? The source rectangle from the image. If nil, the whole image is taken as the source.
---@param path string The image's absolute path on disk.
---@param color ColorSource? The color filter applied to the image. If nil or white, the image is drawn with no tint.
---@param filter "nearest" | "linear" The texture filter applied to the image.
BreitbandGraphics.draw_image = function(destination_rectangle, source_rectangle, path, color, filter)
    if not filter then
        filter = 'nearest'
    end
    local float_color
    if color then
        float_color = color_source_to_float_color(color)
    else
        float_color = BreitbandGraphics.colors.white
    end
    local image = BreitbandGraphics.internal.image_from_path(path)
    local interpolation = filter == 'nearest' and 0 or 1

    if not source_rectangle then
        local size = BreitbandGraphics.get_image_info(path)
        source_rectangle = {
            x = 0,
            y = 0,
            width = size.width,
            height = size.height,
        }
    end

    d2d.draw_image(
        destination_rectangle.x,
        destination_rectangle.y,
        destination_rectangle.x + destination_rectangle.width,
        destination_rectangle.y + destination_rectangle.height,
        source_rectangle.x,
        source_rectangle.y,
        source_rectangle.x + source_rectangle.width,
        source_rectangle.y + source_rectangle.height,
        float_color.a,
        interpolation,
        image)
end

---Gets information about an image.
---@param path string The image's absolute path on disk.
---@return ImageInfo # Information about the image.
BreitbandGraphics.get_image_info = function(path)
    local image = BreitbandGraphics.internal.image_from_path(path)
    return d2d.get_image_info(image)
end

---Releases allocated resources.
---Must be called before stopping the Lua environment.
BreitbandGraphics.free = function()
    for key, value in pairs(BreitbandGraphics.internal.brushes) do
        d2d.free_brush(value)
    end
    for key, value in pairs(BreitbandGraphics.internal.images) do
        d2d.free_image(value)
    end
end
