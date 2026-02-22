BreitbandGraphics.internal = {
    ---@type table<string, integer>
    ---Map of color keys to brush handles.
    brushes = {},

    ---@type table<string, integer>
    ---Map of image paths to image handles.
    images = {},

    --- Creates a FloatColor from a Color.
    --- Channels with nil values will be converted to `0.0`, unless they are the alpha channel, in which case it will be converted to `1.0`.
    --- @param color Color The color to be converted.
    --- @return FloatColor # The color with remapped channels.
    color_to_float = function(color)
        return {
            r = (color.r and (color.r / 255.0) or 0.0),
            g = (color.g and (color.g / 255.0) or 0.0),
            b = (color.b and (color.b / 255.0) or 0.0),
            a = (color.a and (color.a / 255.0) or 1.0),
        }
    end,

    ---Convers a color source to a FloatColor.
    ---@param source ColorSource The color source.
    ---@return FloatColor # The converted color.
    color_source_to_float_color = function(source)
        -- Match RawColor
        if math.type(source) == "integer" then
            return {
                r = (source >> 24) & 0xFF,
                g = (source >> 16) & 0xFF,
                b = (source >> 8) & 0xFF,
                a = source & 0xFF,
            }
        end

        -- Match HexColor
        if type(source) == 'string' then
            return BreitbandGraphics.internal.color_to_float(BreitbandGraphics.hex_to_color(source))
        end

        -- Match ArrayColor and ArrayFloatColor
        if source[1] or source[2] or source[3] or source[4] then
            -- Match ArrayFloatColor
            if math.type(source[1]) == 'float' or math.type(source[2]) == 'float' or math.type(source[3]) == 'float' then
                return {
                    r = source[1] or 0.0,
                    g = source[2] or 0.0,
                    b = source[3] or 0.0,
                    a = source[4] or 1.0,
                }
            end

            -- Match ArrayColor
            return BreitbandGraphics.internal.color_to_float({
                r = source[1] or 0,
                g = source[2] or 0,
                b = source[3] or 0,
                a = source[4] or 255,
            })
        end

        -- Match FloatColor
        if math.type(source.r) == 'float' or math.type(source.g) == 'float' or math.type(source.b) == 'float' then
            return {
                r = source.r and source.r or 0.0,
                g = source.g and source.g or 0.0,
                b = source.b and source.b or 0.0,
                a = source.a and source.a or 1.0,
            }
        end

        -- Match Color
        if math.type(source.r) == 'integer' or math.type(source.g) == 'integer' or math.type(source.b) == 'integer' then
            return BreitbandGraphics.internal.color_to_float(source)
        end

        if type(source) == "table" then
            return BreitbandGraphics.internal.color_to_float({})
        end

        print('Invalid color source:')
        print(source)
        error('See above.')
    end,
}
