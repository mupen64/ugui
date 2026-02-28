--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Color
---@field public r integer The red channel in the range 0 - 255.
---@field public g integer The green channel in the range 0 - 255.
---@field public b integer The blue channel in the range 0 - 255.
---@field public a integer? The alpha channel in the range 0 - 255. If nil, 255 is assumed.

---@class FloatColor
---@field public r number The red channel in the range 0.0 - 1.0.
---@field public g number The green channel in the range 0.0 - 1.0.
---@field public b number The blue channel in the range 0.0 - 1.0.
---@field public a number? The alpha channel in the range 0.0 - 1.0. If nil, 1.0 is assumed.

---@alias ArrayColor { [1]: integer, [2]: integer, [3]: integer, [4]: integer? }
---An integer color array in the format `{r, g, b, a?}`, with channels in the range 0 - 255.

---@alias ArrayFloatColor { [1]: number, [2]: number, [3]: number, [4]: number? }
---An integer color array in the format `{r, g, b, a?}`, with channels in the range 0.0 - 1.0.

---@alias HexColor string
---A hexadecimal color string in the format `#RRGGBB` or `#RRGGBBAA`.

---@alias RawColor integer
---A raw color value in the format `0xRRGGBBAA`.

---@alias ColorSource Color|FloatColor|ArrayColor|ArrayFloatColor|HexColor|RawColor
---A color-providing object that can be converted to a Color.

---@class Vector2
---@field public x number The X component.
---@field public y number The Y component.

---@class Size
---@field public width number The width.
---@field public height number The height.

---@class Rectangle
---@field public x number The X coordinate.
---@field public y number The Y coordinate.
---@field public width number The width.
---@field public height number The height.

---@class TextStyle
---@field public is_bold boolean? Whether the text is bold. If nil, false is assumed.
---@field public is_italic boolean? Whether the text is italic. If nil, false is assumed.
---@field public clip boolean? Whether the text should be clipped to the bounding rectangle. If nil, false is assumed.
---@field public grayscale boolean? Whether the text should be drawn in grayscale. If nil, false is assumed.
---@field public aliased boolean? Whether the text should be drawn with no text filtering. If nil, false is assumed.
---@field public fit boolean? Whether the text should be resized to fit the bounding rectangle. If nil, false is assumed.

---@class DrawTextParams
---@field public text string? The text. If nil, no text will be drawn.
---@field public rectangle Rectangle The text's bounding rectangle.
---@field public color ColorSource The text color.
---@field public font_name string The font name.
---@field public font_size number The font size.
---@field public align_x Alignment? The text's horizontal alignment inside the bounding rectangle. If nil, Alignment.center is assumed.
---@field public align_y Alignment? The text's vertical alignment inside the bounding rectangle. If nil, Alignment.center is assumed.
---@field public is_bold boolean? Whether the text is bold. If nil, false is assumed.
---@field public is_italic boolean? Whether the text is italic. If nil, false is assumed.
---@field public clip boolean? Whether the text should be clipped to the bounding rectangle. If nil, false is assumed.
---@field public grayscale boolean? Whether the text should be drawn in grayscale. If nil, false is assumed.
---@field public aliased boolean? Whether the text should be drawn with no text filtering. If nil, false is assumed.
---@field public fit boolean? Whether the text should be resized to fit the bounding rectangle. If nil, false is assumed.

---@class ImageInfo
---@field public width number The width.
---@field public height number The height.
---Contains information about an image.

---@enum StandardColors
--- A table of standard colors.
BreitbandGraphics.colors = {
    --- The color white.
    white = {
        r = 255,
        g = 255,
        b = 255,
    },

    --- The color black.
    black = {
        r = 0,
        g = 0,
        b = 0,
    },

    --- The color red.
    red = {
        r = 255,
        g = 0,
        b = 0,
    },

    --- The color green.
    green = {
        r = 0,
        g = 255,
        b = 0,
    },

    --- The color blue.
    blue = {
        r = 0,
        g = 0,
        b = 255,
    },

    --- The color yellow.
    yellow = {
        r = 255,
        g = 255,
        b = 0,
    },

    --- The color orange.
    orange = {
        r = 255,
        g = 128,
        b = 0,
    },

    --- The color magenta.
    magenta = {
        r = 255,
        g = 0,
        b = 255,
    },
}

---@enum Alignment
--- The alignment inside a container.
BreitbandGraphics.alignment = {
    --- The item is aligned to the start of the container.
    start = 1,
    --- The item is aligned to the center of the container.
    center = 2,
    --- The item is aligned to the end of the container.
    ['end'] = 3,
    --- The item is stretched to fill the container.
    stretch = 4,
}
