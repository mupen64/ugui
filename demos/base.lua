local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\')
local test_root = debug.getinfo(1).short_src:gsub('(\\[^\\]+)\\[^\\]+$', '%1\\')

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'build\\breitbandgraphics-amalgamated.lua')

---@module "ugui"
ugui = dofile(path_root .. 'build\\ugui-amalgamated.lua')

local frame_times = {}
local last_frame_time = nil

local function new_frametime()
    local now = os.clock()
    if last_frame_time ~= nil then
        local frametime = now - last_frame_time
        frame_times[#frame_times + 1] = { t = now, dt = frametime }
    end
    last_frame_time = now

    local cutoff = now - 1.0
    local i = 1
    while i <= #frame_times and frame_times[i].t < cutoff do
        table.remove(frame_times, i)
    end

    local avg_ms = 0
    if #frame_times > 0 then
        local sum = 0
        for _, entry in ipairs(frame_times) do
            sum = sum + entry.dt
        end
        avg_ms = (sum / #frame_times) * 1000
    end

    return string.format('%.2f ms', avg_ms)
end

function begin_frame()
    local window_size = wgui.info()

    BreitbandGraphics.fill_rectangle({
        x = 0,
        y = 0,
        width = window_size.width,
        height = window_size.height,
    }, {
        r = 253,
        g = 253,
        b = 253,
    })

    local keys = input.get()
    ugui.begin_frame({
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
        window_size = {
            x = window_size.width,
            y = window_size.height - 23,
        },
    })
    mouse_wheel = 0
end

function end_frame()
    ugui.end_frame()

    local label = new_frametime()
    BreitbandGraphics.draw_text2({
        rectangle = { x = 4, y = 4, width = 200, height = 16 },
        align_x = BreitbandGraphics.alignment.start,
        align_y = BreitbandGraphics.alignment.center,
        text = label,
        color = { r = 0, g = 0, b = 0 },
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
    })
end

emu.atwindowmessage(function(_, msg_id, wparam, _)
    if msg_id == 522 then
        local scroll = math.floor(wparam / 65536)
        if scroll == 120 then
            mouse_wheel = 1
        elseif scroll == 65416 then
            mouse_wheel = -1
        end
    end
end)
