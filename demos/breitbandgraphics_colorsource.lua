local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    BreitbandGraphics.fill_rectangle({
        x = 0,
        y = 50,
        width = 100,
        height = 100,
    }, '#FF0000')
    BreitbandGraphics.fill_rectangle({
        x = 100,
        y = 50,
        width = 100,
        height = 100,
    }, {r = 255})
    BreitbandGraphics.fill_rectangle({
        x = 200,
        y = 50,
        width = 100,
        height = 100,
    }, {r = 1.0})
    BreitbandGraphics.fill_rectangle({
        x = 300,
        y = 50,
        width = 100,
        height = 100,
    }, {1.0})
    BreitbandGraphics.fill_rectangle({
        x = 400,
        y = 50,
        width = 100,
        height = 100,
    }, {255})
    BreitbandGraphics.fill_rectangle({
        x = 500,
        y = 50,
        width = 100,
        height = 100,
    }, -16776961)
end)
