local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\')

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "ugui"
ugui = dofile(path_root .. 'ugui.lua')

local vstackpanel = ugui.add(nil, {
    class = ugui.STACKPANEL,
    font_size = 40,
    font_name = 'Consolas',
})

ugui.add(vstackpanel, {
    class = ugui.TEXTBLOCK,
    text = 'A',
})

local hstackpanel = ugui.add(vstackpanel, {
    class = ugui.STACKPANEL,
    horizontal = true,
})

ugui.add(hstackpanel, {
    class = ugui.TEXTBLOCK,
    text = 'A',
})

ugui.add(hstackpanel, {
    class = ugui.TEXTBLOCK,
    text = 'B',
})

ugui.add(hstackpanel, {
    class = ugui.TEXTBLOCK,
    text = 'C',
})

ugui.add(vstackpanel, {
    class = ugui.TEXTBLOCK,
    text = 'D',
})

ugui.start()
