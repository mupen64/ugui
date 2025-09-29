local path_root = debug.getinfo(1).source:sub(2):gsub("\\[^\\]+\\[^\\]+$", "\\")

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
local mouse_wheel = 0

local align_x = 2
local align_y = 2
local plaintext = false

local alignments = {
    'Start [icon:arrow_left]',
    'Center [icon:arrow_up]',
    'End [icon:arrow_right]',
}

emu.atdrawd2d(function()
    BreitbandGraphics.fill_rectangle({
        x = 0,
        y = 0,
        width = wgui.info().width,
        height = wgui.info().height,
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
            x = wgui.info().width,
            y = wgui.info().height,
        },
    })
    mouse_wheel = 0

    ugui.button({
        uid = 1,
        rectangle = {x = 20, y = 20, width = 100, height = 100},
        text = '[icon:arrow_left]Go Back',
        tooltip = 'In the [icon:arrow_up] middle',
        plaintext = plaintext,
    })

    align_x = ugui.combobox({
        uid = 5,
        rectangle = {x = 200, y = 20, width = 90, height = 20},
        items = alignments,
        selected_index = align_x,
        plaintext = plaintext,
    })

    align_y = ugui.combobox({
        uid = 10,
        rectangle = {x = 200, y = 100, width = 90, height = 20},
        items = alignments,
        selected_index = align_y,
        plaintext = plaintext,
    })

    plaintext = ugui.toggle_button({
        uid = 15,
        rectangle = {x = 200, y = 130, width = 90, height = 20},
        text = 'Plaintext',
        is_checked = plaintext,
        tooltip = "Whether the control's text content is drawn as plain text without rich rendering.",
    })

    ugui.listbox({
        uid = 20,
        rectangle = {x = 200, y = 160, width = 140, height = 300},
        items = {
            '[icon:arrow_up] Hello',
            '[icon:arrow_up] Hello',
            '[icon:arrow_up] Hello',
            '[icon:arrow_up] Hello',
            '[icon:arrow_up] Hello',
            '[icon:arrow_up] Hello',
            'ok[icon:arrow_right][icon:arrow_right]',
        },
        plaintext = plaintext,
        selected_index = 1,
    })

    local rect = {
        x = 350,
        y = 20,
        width = 200,
        height = 200,
    }

    BreitbandGraphics.draw_rectangle(rect, BreitbandGraphics.colors.red, 2)
    ugui.standard_styler.draw_rich_text(rect, align_x, align_y, '[icon:arrow_up:#FF00FF]party time[icon:arrow_up:textbox.selection]', BreitbandGraphics.colors.black, ugui.visual_states.normal, plaintext)

    ugui.end_frame()
end)

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
