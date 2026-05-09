local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

ugui.DEBUG = true

local pages = {
    function()
        ugui.button({
            uid = 10,
            text = '',
            size = '30% 30%',
            align = 'center',
            padding = '20px',
        }, function()
            ugui.button({
                uid = 20,
                text = 'top left',
            })
            ugui.button({
                uid = 30,
                text = 'top center',
                align = 'center top',
            })
            ugui.button({
                uid = 40,
                text = 'top right',
                align = 'right top',
            })
            ugui.button({
                uid = 50,
                text = 'center left',
                align = 'left center',
            })
            ugui.button({
                uid = 60,
                text = 'center center',
                align = 'center',
                padding = '20px',
            })
            ugui.button({
                uid = 70,
                text = 'center right',
                align = 'right center',
            })
            ugui.button({
                uid = 80,
                text = 'bottom left',
                align = 'left bottom',
            })
            ugui.button({
                uid = 90,
                text = 'bottom center',
                align = 'center bottom',
            })
            ugui.button({
                uid = 100,
                text = 'bottom right',
                align = 'right bottom',
            })
        end)
    end,
    function()
        _sl = _sl or 1
        _sl = ugui.listbox({
            uid = 110,
            align = 'center',
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
            uid = 120,
            align = 'center',
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
            uid = 130,
            align = 'center',
            padding = '100px 10px',
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
    function()
        _open = _open or false

        if ugui.button({
                uid = 140,
                align = '90% 90%',
                text = 'Open Menu...',
                padding = '20px',
            }) then
            _open = true
        end

        if _open then
            local result = ugui.menu({
                uid = 150,
                align = '90% 90%',
                items = {
                    {text = 'Item 1', checked = true},
                    {text = 'Item 2', enabled = false},
                    {text = 'Item 3'},
                    {text = 'Item 4'},
                    {text = 'Item 5'},
                    {
                        text = 'Item 6',
                        items = {
                            {text = 'Item 6.1'},
                            {text = 'Item 6.2'},
                            {text = 'Item 6.3'},
                        },
                    },
                    {text = 'Item 7'},
                    {
                        text = 'Item 8',
                        enabled = false,
                        items = {
                            {text = 'Item 8.1'},
                            {text = 'Item 8.2'},
                            {text = 'Item 8.3'},
                        },
                    },
                },
            }).primary

            if result.dismissed or result.item then
                _open = false
            end

            if result.item then
                print(result.item)
            end
        end
    end,
    function()
        _sl4 = _sl4 or 1
        _tab_count = _tab_count or 5

        local items = {}
        for i = 1, _tab_count do
            items[i] = 'Tab ' .. i
        end

        local result = ugui.tabcontrol({
            uid = 160,
            align = 'center',
            size = '200px 400px',
            items = items,
            selected_index = _sl4,
            styler_mixin = {tabcontrol = {gap_y = 10}},
        })
        if result.selected_index then
            _sl4 = result.selected_index
        end
        if ugui.button({
                uid = 300,
                rectangle = result.rectangle,
                text = items[_sl4] .. ' - click to add more items',
            }) then
            _tab_count = _tab_count + 5
        end
    end,
}

local page = 1

emu.atdrawd2d(function()
    begin_frame()

    ugui.label({
        uid = 2,
        size = '100% auto',
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
