local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local items = {}
for i = 1, 1000, 1 do
    items[#items + 1] = 'Item ' .. i
end
local mouse_wheel = 0
local initial_size = wgui.info()
local selected_index = 1
local selected_index_2 = 1
local text = 'a'
local menu_open = false
local menu_items = {
    {
        text = 'Normal item',
    },
    {
        text = 'Disabled item',
        enabled = false,
    },
    {
        text = 'Checkable item',
        checked = true,
    },
    {
        text = 'With subitems right here ok okok',
        items = {
            {
                text = 'Subitem #1',
            },
            {
                text = 'Subitem #2',
                checked = true,
            },
            {
                text = 'Subitem #3',
                items = {
                    {
                        text = 'Subitem #4',
                    },
                    {
                        text = 'Subitem #5',
                        checked = true,
                    },
                    {
                        text = 'Subitem #6',
                        enabled = false,
                        items = {
                            {
                                text = 'Should never appear',
                            },
                        },
                    },
                    {
                        text = 'Subitem #7',
                        items = {

                            {
                                text = 'Normal item',
                            },
                            {
                                text = 'Disabled item',
                                enabled = false,
                            },
                            {
                                text = 'Checkable item',
                                checked = true,
                            },
                            {
                                text = 'With subitems right here ok okok',
                                items = {
                                    {
                                        text = 'Subitem #1',
                                    },
                                    {
                                        text = 'Subitem #2',
                                        checked = true,
                                    },
                                    {
                                        text = 'Subitem #3',
                                        items = {
                                            {
                                                text = 'Subitem #4',
                                            },
                                            {
                                                text = 'Subitem #5',
                                                checked = true,
                                            },
                                            {
                                                text = 'Subitem #6',
                                                enabled = false,
                                                items = {
                                                    {
                                                        text = 'Should never appear',
                                                    },
                                                },
                                            },
                                            {
                                                text = 'Subitem #7',
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}

emu.atdrawd2d(function()
    begin_frame()

    selected_index = ugui.combobox({
        uid = 0,
        rectangle = {
            x = 5,
            y = 5,
            width = 90,
            height = 20,
        },
        items = items,
        selected_index = selected_index,
    })

    if menu_open then
        local result = ugui.menu({
            uid = 5,
            rectangle = {
                x = 50,
                y = 76,
            },
            items = menu_items,
            z_index = 1,
        })

        if result.dismissed then
            menu_open = false
        end

        if result.item ~= nil then
            menu_open = false
            text = result.item.text
            if result.item.checked ~= nil then
                result.item.checked = not result.item.checked
            end
            print('Chose ' .. result.item.text)
        end
    end

    if ugui.button({
            uid = 500,
            rectangle = {
                x = 5,
                y = 55,
                width = 90,
                height = 20,
            },
            text = text,
        }) then
        menu_open = true
    end

    selected_index_2 = ugui.listbox({
        uid = 1000,
        is_enabled = true,
        rectangle = {
            x = 5,
            y = 80,
            width = 150,
            height = 83,
        },
        items = items,
        selected_index = selected_index_2,
        horizontal_scroll = false,
    })

    ugui.listbox({
        uid = 6000,
        is_enabled = true,
        rectangle = {
            x = 300,
            y = 80,
            width = 200,
            height = 300,
        },
        items = items
    })

    text = ugui.textbox({
        uid = 1500,
        rectangle = {
            x = 5,
            y = 30,
            width = 140,
            height = 20,
        },
        text = text,
    })

    if ugui.button({
            uid = 2000,
            rectangle = {
                x = initial_size.width - 90,
                y = initial_size.height - 90,
                width = 200,
                height = 200,
            },
            text = 'offscreen click',
        }) then
        print(math.random())
    end

    selected_index = ugui.combobox({
        uid = 2500,
        rectangle = {
            x = 720,
            y = 10,
            width = 140,
            height = 20,
        },
        items = items,
        selected_index = selected_index,
    })

    ugui.combobox({
        uid = 3000,
        rectangle = {
            x = initial_size.width - 90,
            y = initial_size.height - 250,
            width = 200,
            height = 30,
        },
        items = {'A', 'B', 'C'},
        selected_index = 1,
    })

    ugui.combobox({
        uid = 3500,
        rectangle = {
            x = 300,
            y = 10,
            width = 200,
            height = 30,
        },
        items = {'A', 'B', 'C'},
        selected_index = 1,
    })

    end_frame()
end)
