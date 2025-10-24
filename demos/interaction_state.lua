local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local interaction_logs = {}
local items = {}
local checked = true
local index = 1

for i = 1, 100, 1 do
    items[#items + 1] = 'Item ' .. i
end

---@param meta Meta
local function log_interaction(meta)
    local text_interaction
    if meta.interaction == ugui.interaction_states.none then
        text_interaction = 'none'
    elseif meta.interaction == ugui.interaction_states.started then
        text_interaction = 'started'
    elseif meta.interaction == ugui.interaction_states.ongoing then
        text_interaction = 'ongoing'
    elseif meta.interaction == ugui.interaction_states.ended then
        text_interaction = 'ended'
    end
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
    })

    local pressed, meta = ugui.button({
        uid = 10,
        rectangle = {x = 120, y = 10, width = 100, height = 23},
        text = 'Hello, world!',
    })
    log_interaction(meta)

    checked, meta = ugui.toggle_button({
        uid = 15,
        rectangle = {x = 120, y = 35, width = 100, height = 23},
        text = 'Hello, world!',
        is_checked = checked,
    })
    log_interaction(meta)

    index, meta = ugui.listbox({
        uid = 20,
        rectangle = {x = 230, y = 40, width = 100, height = 200},
        text = 'Hello, world!',
        items = items,
        selected_index = index,
    })
    log_interaction(meta)

    end_frame()
end)
