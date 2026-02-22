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


    end_frame()
end)
