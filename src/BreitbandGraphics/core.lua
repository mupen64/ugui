--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

--- Converts a color to its corresponding hexadecimal representation.
--- @param color ColorSource The color source to convert.
--- @returns string # The hexadecimal representation of the color.
BreitbandGraphics.color_to_hex = function(color)
    local converted = BreitbandGraphics.float_to_color(BreitbandGraphics.internal.color_source_to_float_color(color))
    return string.format('#%06X', (converted.r * 0x10000) + (converted.g * 0x100) + converted.b)
end

--- Converts a color's hexadecimal representation into a color table.
--- @param hex string The hexadecimal color to convert.
--- @return Color # The color.
BreitbandGraphics.hex_to_color = function(hex)
    if #hex > 7 then
        return
        {
            r = tonumber(hex:sub(2, 3), 16),
            g = tonumber(hex:sub(4, 5), 16),
            b = tonumber(hex:sub(6, 7), 16),
            a = tonumber(hex:sub(8, 9), 16),
        }
    end
    return
    {
        r = tonumber(hex:sub(2, 3), 16),
        g = tonumber(hex:sub(4, 5), 16),
        b = tonumber(hex:sub(6, 7), 16),
    }
end

--- Creates a color with the red, green and blue channels assigned to the specified value.
--- @param value number The value to be used for the red, green and blue channels.
--- @return Color # The color with the red, green and blue channels set to the specified value.
BreitbandGraphics.repeated_to_color = function(value)
    return
    {
        r = value,
        g = value,
        b = value,
    }
end

---Inverts a color source.
---@param color ColorSource The color source to invert.
---@return Color # The new inverted color.
BreitbandGraphics.invert_color = function(color)
    local converted = BreitbandGraphics.internal.color_source_to_float_color(color)
    return BreitbandGraphics.float_to_color({
        r = 1.0 - converted.r,
        g = 1.0 - converted.g,
        b = 1.0 - converted.b,
        a = converted.a,
    })
end

--- Creates a FloatColor from a ColorSource.
--- Channels with nil values will be converted to `0.0`, unless they are the alpha channel, in which case it will be converted to `1.0`.
--- @param color ColorSource The color to be converted.
--- @return FloatColor # The color with remapped channels.
BreitbandGraphics.color_to_float = function(color)
    return BreitbandGraphics.internal.color_source_to_float_color(color)
end

--- Creates a Color from a FloatColor.
--- Channels with nil values will be converted to `0`, unless they are the alpha channel, in which case it will be converted to `255`.
--- @param color FloatColor The color to be converted.
--- @return Color # The color with remapped channels.
BreitbandGraphics.float_to_color = function(color)
    return {
        r = (color.r and (math.tointeger(math.floor(color.r * 255 + 0.5))) or 0),
        g = (color.g and (math.tointeger(math.floor(color.g * 255 + 0.5))) or 0),
        b = (color.b and (math.tointeger(math.floor(color.b * 255 + 0.5))) or 0),
        a = (color.a and (math.tointeger(math.floor(color.a * 255 + 0.5))) or 255),
    }
end

---Checks whether a point is inside a rectangle.
---@param point Vector2 The point.
---@param rectangle Rectangle The rectangle.
---@return boolean # Whether the point is inside the rectangle.
BreitbandGraphics.is_point_inside_rectangle = function(point, rectangle)
    return point.x > rectangle.x and
        point.y > rectangle.y and
        point.x < rectangle.x + rectangle.width and
        point.y < rectangle.y + rectangle.height
end

---Checks whether a point is inside any of the rectangles.
---@param point Vector2 The point.
---@param rectangles Rectangle[] The rectangles.
---@return boolean # Whether the point is inside any of the rectangles.
BreitbandGraphics.is_point_inside_any_rectangle = function(point, rectangles)
    for i = 1, #rectangles, 1 do
        if BreitbandGraphics.is_point_inside_rectangle(point, rectangles[i]) then
            return true
        end
    end
    return false
end

--- Creates a rectangle inflated around its center by the specified amount.
--- @param rectangle Rectangle The rectangle to be inflated.
--- @param amount number The amount to inflate the rectangle by.
--- @return Rectangle # The inflated rectangle.
BreitbandGraphics.inflate_rectangle = function(rectangle, amount)
    return {
        x = rectangle.x - amount,
        y = rectangle.y - amount,
        width = rectangle.width + amount * 2,
        height = rectangle.height + amount * 2,
    }
end


---Draws a nineslice-scalable image with the specified parameters.
---@param destination_rectangle Rectangle The destination rectangle on the screen.
---@param source_rectangle Rectangle The source rectangle from the image.
---@param source_rectangle_center Rectangle The source rectangle for the center of the image.
---@param path string The image's absolute path on disk.
---@param color ColorSource The color filter applied to the image. If white, the image is drawn as-is.
---@param filter "nearest" | "linear" The texture filter applied to the image.
BreitbandGraphics.draw_image_nineslice = function(destination_rectangle, source_rectangle, source_rectangle_center, path,
                                                  color, filter)
    destination_rectangle = {
        x = math.floor(destination_rectangle.x),
        y = math.floor(destination_rectangle.y),
        width = math.ceil(destination_rectangle.width),
        height = math.ceil(destination_rectangle.height),
    }
    source_rectangle = {
        x = math.floor(source_rectangle.x),
        y = math.floor(source_rectangle.y),
        width = math.ceil(source_rectangle.width),
        height = math.ceil(source_rectangle.height),
    }
    local corner_size = {
        x = math.abs(source_rectangle_center.x - source_rectangle.x),
        y = math.abs(source_rectangle_center.y - source_rectangle.y),
    }


    local top_left = {
        x = source_rectangle.x,
        y = source_rectangle.y,
        width = corner_size.x,
        height = corner_size.y,
    }
    local bottom_left = {
        x = source_rectangle.x,
        y = source_rectangle_center.y + source_rectangle_center.height,
        width = corner_size.x,
        height = corner_size.y,
    }
    local left = {
        x = source_rectangle.x,
        y = source_rectangle_center.y,
        width = corner_size.x,
        height = source_rectangle.height - corner_size.y * 2,
    }
    local top_right = {
        x = source_rectangle.x + source_rectangle.width - corner_size.x,
        y = source_rectangle.y,
        width = corner_size.x,
        height = corner_size.y,
    }
    local bottom_right = {
        x = source_rectangle.x + source_rectangle.width - corner_size.x,
        y = source_rectangle_center.y + source_rectangle_center.height,
        width = corner_size.x,
        height = corner_size.y,
    }
    local top = {
        x = source_rectangle_center.x,
        y = source_rectangle.y,
        width = source_rectangle.width - corner_size.x * 2,
        height = corner_size.y,
    }
    local right = {
        x = source_rectangle.x + source_rectangle.width - corner_size.x,
        y = source_rectangle_center.y,
        width = corner_size.x,
        height = source_rectangle.height - corner_size.y * 2,
    }
    local bottom = {
        x = source_rectangle_center.x,
        y = source_rectangle.y + source_rectangle.height - corner_size.y,
        width = source_rectangle.width - corner_size.x * 2,
        height = corner_size.y,
    }

    BreitbandGraphics.draw_image({
        x = destination_rectangle.x,
        y = destination_rectangle.y,
        width = top_left.width,
        height = top_left.height,
    }, top_left, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x + destination_rectangle.width - top_right.width,
        y = destination_rectangle.y,
        width = top_right.width,
        height = top_right.height,
    }, top_right, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x,
        y = destination_rectangle.y + destination_rectangle.height - bottom_left.height,
        width = bottom_left.width,
        height = bottom_left.height,
    }, bottom_left, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x + destination_rectangle.width - bottom_right.width,
        y = destination_rectangle.y + destination_rectangle.height - bottom_right.height,
        width = bottom_right.width,
        height = bottom_right.height,
    }, bottom_right, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x + top_left.width,
        y = destination_rectangle.y + top_left.height,
        width = destination_rectangle.width - bottom_right.width * 2,
        height = destination_rectangle.height - bottom_right.height * 2,
    }, source_rectangle_center, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x,
        y = destination_rectangle.y + top_left.height,
        width = left.width,
        height = destination_rectangle.height - bottom_left.height * 2,
    }, left, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x + destination_rectangle.width - top_right.width,
        y = destination_rectangle.y + top_right.height,
        width = left.width,
        height = destination_rectangle.height - bottom_right.height * 2,
    }, right, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x + top_left.width,
        y = destination_rectangle.y,
        width = destination_rectangle.width - top_right.width * 2,
        height = top.height,
    }, top, path, color, filter)
    BreitbandGraphics.draw_image({
        x = destination_rectangle.x + top_left.width,
        y = destination_rectangle.y + destination_rectangle.height - bottom.height,
        width = destination_rectangle.width - bottom_right.width * 2,
        height = bottom.height,
    }, bottom, path, color, filter)
end
