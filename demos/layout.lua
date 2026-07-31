local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

ugui.DEBUG = true

local pages = {
    function()
        ugui.button({
            uid = 100,
            text = '',
            size = '0.3 0.3',
            align = '0.5',
            padding = '20px',
        }, function()
            ugui.button({
                uid = 200,
                text = 'top left',
            })
            ugui.button({
                uid = 300,
                text = 'top center',
                align = '0.5 0',
            })
            ugui.button({
                uid = 400,
                text = 'top right',
                align = '1 0',
            })
            ugui.button({
                uid = 500,
                text = 'center left',
                align = '0 0.5',
            })
            ugui.button({
                uid = 600,
                text = 'center center',
                align = '0.5',
                padding = '20px',
            })
            ugui.button({
                uid = 700,
                text = 'center right',
                align = '1 0.5',
            })
            ugui.button({
                uid = 800,
                text = 'bottom left',
                align = '0 1',
            })
            ugui.button({
                uid = 900,
                text = 'bottom center',
                align = '0.5 1',
            })
            ugui.button({
                uid = 1000,
                text = 'bottom right',
                align = '1 1',
            })
        end)
    end,
    function()
        _sl = _sl or 1
        _sl = ugui.listbox({
            uid = 1100,
            align = '0.5',
            items = {
                'Item 1',
                'Item 2',
                'Item 3',
                'Item 4',
                'Item 5',
            },
            selected_index = _sl,
        })
    end,
    function()
        _sl2 = _sl2 or 1
        _sl2 = ugui.listbox({
            uid = 1200,
            align = '0.5',
            size = '130px 130px',
            horizontal_scroll = true,
            items = {
                'Item Item Item Item Item Item Item Item Item 1',
                'Item Item Item Item Item Item Item Item Item 2',
                'Item Item Item Item Item Item Item Item Item 3',
                'Item Item Item Item Item Item Item Item Item 4',
                'Item Item Item Item Item Item Item Item Item 5',
                'Item Item Item Item Item Item Item Item Item 6',
                'Item Item Item Item Item Item Item Item Item 7',
                'Item Item Item Item Item Item Item Item Item 8',
                'Item Item Item Item Item Item Item Item Item 9',
                'Item Item Item Item Item Item Item Item Item 10000000',
                'Item Item Item Item Item Item Item Item Item 10000000',
                'Item Item Item Item Item Item Item Item Item 10000000',
                'Item Item Item Item Item Item Item Item Item 10000000',
                'Item Item Item Item Item Item Item Item Item 10000000',
            },
            selected_index = _sl2,
        })
    end,
    function()
        _sl3 = _sl3 or 1
        _sl3 = ugui.combobox({
            uid = 1300,
            align = '0.5',
            padding = '40px 10px',
            items = {
                'Item 1',
                'Item 2',
                'Item 3',
                'Item 4',
                'Item 5',
            },
            selected_index = _sl3,
        })
    end,
}

local page = 1

emu.atdrawd2d(function()
    begin_frame()

    ugui.label({
        uid = 1400,
        size = '1 auto',
        font_size = 24,
        text = string.format('Press left/right arrows to switch pages (%d/%d)', page, #pages),
        color = {r = 0, g = 0, b = 0},
    })

    pages[page]()

    for _, e in ipairs(ugui.internal.environment.key_events) do
        if e.pressed and e.keycode == ugui.keycodes.VK_LEFT then
            page = page - 1
            if page < 1 then page = #pages end
        elseif e.pressed and e.keycode == ugui.keycodes.VK_RIGHT then
            page = page + 1
            if page > #pages then page = 1 end
        end
    end

    end_frame()
end)
