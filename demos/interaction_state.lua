local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local interaction_logs = { 'none' }
local items = {}
local checked = true
local index = 1
local combobox_selected_index = 1

for i = 1, 100, 1 do
    items[#items + 1] = 'Item ' .. i
end

---@param meta Meta
local function log_interaction(meta, value)
    local text_interaction
    if meta.signal_change == ugui.signal_change_states.none then
        text_interaction = 'none'
    elseif meta.signal_change == ugui.signal_change_states.started then
        text_interaction = 'started'
    elseif meta.signal_change == ugui.signal_change_states.ongoing then
        text_interaction = 'ongoing'
    elseif meta.signal_change == ugui.signal_change_states.ended then
        text_interaction = 'ended, finally'
    end
    text_interaction = text_interaction .. "(" .. tostring(value) .. ")"
    if interaction_logs[#interaction_logs] == text_interaction then
        return
    end
    interaction_logs[#interaction_logs + 1] = text_interaction
end

emu.atdrawd2d(function()
    begin_frame()

    ugui.listbox({
        uid = 1,
        rectangle = {x = 10, y = 40, width = 100, height = 200},
        items = interaction_logs,
        selected_index = nil,
        horizontal_scroll = true,
    })

    local pressed, meta = ugui.button({
        uid = 10,
        rectangle = {x = 120, y = 10, width = 100, height = 23},
        text = 'Hello, world!',
    })

    checked, meta = ugui.toggle_button({
        uid = 15,
        rectangle = {x = 120, y = 35, width = 100, height = 23},
        text = 'Hello, world!',
        is_checked = checked,
    })

    index, meta = ugui.listbox({
        uid = 20,
        rectangle = {x = 230, y = 40, width = 100, height = 200},
        text = 'Hello, world!',
        items = items,
        selected_index = index,
    })

    local new_index, meta = ugui.combobox({
        uid = 25,
        rectangle = {x = 350, y = 40, width = 100, height = 30},
        items = {'One', 'Two which is very long', 'Three', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More', 'More'},
        selected_index = combobox_selected_index,
        editable = true,
        preview_change = true,
    })
    if meta.signal_change == ugui.signal_change_states.ended then
        combobox_selected_index = new_index
    end
    log_interaction(meta, new_index)

    end_frame()
end)
