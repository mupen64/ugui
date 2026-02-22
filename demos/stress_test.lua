local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

emu.atdrawd2d(function()
    begin_frame()
    local i = 0
    local size = wgui.info()
    for x = 1, size.width / 20, 1 do
        for y = 1, size.height / 20, 1 do
            ugui.button({
                uid = i,
                rectangle = {
                    x = (x - 1) * 20,
                    y = (y - 1) * 20,
                    width = 20,
                    height = 20,
                },
                text = ':)',
                styler_mixin = {
                    button = {
                        back = {
                            [1] = BreitbandGraphics.hex_to_color('#FF0000')
                        }
                    }
                }
            })
            i = i + 1
        end
    end

    end_frame()
end)
