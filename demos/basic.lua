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

local b = ugui.add(hstackpanel, {
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

local keys = {}
local prev_keys = {}

emu.atdrawd2d(function()
    keys = input.get()
    local new_keys = input.diff(keys, prev_keys)

    if new_keys['R'] then
        ugui.set_prop(hstackpanel, 'horizontal', not ugui.get_prop(hstackpanel, 'horizontal'))
    end

    if new_keys['up'] then
        local margin = ugui.get_prop(b, 'margin')
        ugui.set_prop(b, 'margin', {margin[1], margin[2] + 100, margin[3], margin[4]})
    end

    prev_keys = ugui.internal.deep_clone(keys)
end)
