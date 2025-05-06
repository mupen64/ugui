local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\')

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "ugui"
ugui = dofile(path_root .. 'ugui.lua')

local stackpanel = ugui.add(nil, {
    class = ugui.STACKPANEL,
    x_align = ugui.ALIGNMENTS.center,
    y_align = ugui.ALIGNMENTS.center,
})

-- local button = ugui.add(stackpanel, {
--     class = ugui.BUTTON,
--     x_align = ugui.ALIGNMENTS.stretch,
--     y_align = ugui.ALIGNMENTS.stretch,
-- })

local textblock = ugui.add(stackpanel, {
    class = ugui.TEXTBLOCK,
    x_align = ugui.ALIGNMENTS.start,
    text = 'Hello!',
})

local textblock = ugui.add(stackpanel, {
    class = ugui.TEXTBLOCK,
    text = 'Hello World!',
})

local textblock = ugui.add(stackpanel, {
    class = ugui.TEXTBLOCK,
    x_align = ugui.ALIGNMENTS['end'],
    text = 'Hello!',
})

ugui.start()
