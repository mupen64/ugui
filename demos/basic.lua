local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\')

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "ugui"
ugui = dofile(path_root .. 'ugui.lua')

local stackpanel = ugui.add(nil, {
    class = ugui.STACKPANEL,
    x_align = ugui.ALIGNMENTS.center,
    y_align = ugui.ALIGNMENTS.center,
    font_size = 40,
    font_name = 'Comic Sans MS',
})

local button = ugui.add(stackpanel, {
    class = ugui.BUTTON,
    x_align = ugui.ALIGNMENTS.start,
})

local textblock = ugui.add(button, {
    class = ugui.TEXTBLOCK,
    x_align = ugui.ALIGNMENTS.start,
    margin = {50, 0, 0, 0},
    text = 'Hello!',
})

-- local textblock = ugui.add(stackpanel, {
--     class = ugui.TEXTBLOCK,
--     margin = {0, 0, 50, 0},
--     text = 'Hello World!',
-- })

-- local textblock = ugui.add(stackpanel, {
--     class = ugui.TEXTBLOCK,
--     x_align = ugui.ALIGNMENTS['end'],
--     margin = {50, 50, 50, 50},
--     text = 'Hello!',
-- })

ugui.start()
