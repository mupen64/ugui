local path_root = debug.getinfo(1).source:sub(2):gsub('\\[^\\]+\\[^\\]+$', '\\') .. 'demos\\'
dofile(path_root .. 'base.lua')

local peppers_path = path_root .. 'res\\peppers.png'

local COL1_X = 10
local COL2_X = 220
local COL3_X = 430
local ROW1_Y = 20
local ROW2_Y = 210
local IMG_W = 160
local IMG_H = 160
local LABEL_H = 23

emu.atdrawd2d(function()
    begin_frame()

    local info = BreitbandGraphics.get_image_info(peppers_path)

    do
        local x, y = COL1_X, ROW1_Y
        ugui.label({
            uid = 1,
            rectangle = {x = x, y = y, width = IMG_W, height = LABEL_H},
            text = '1. Natural size (destx2/y2 = nil)',
            color = BreitbandGraphics.colors.black,
        })
        BreitbandGraphics.push_clip({x = x, y = y + LABEL_H, width = IMG_W, height = IMG_H})
        BreitbandGraphics.draw_image2({
            path = peppers_path,
            destx1 = x,
            desty1 = y + LABEL_H,
        })
        BreitbandGraphics.pop_clip()
    end

    do
        local x, y = COL2_X, ROW1_Y
        ugui.label({
            uid = 2,
            rectangle = {x = x, y = y, width = IMG_W, height = LABEL_H},
            text = '2. Scaled to ' .. IMG_W .. 'x' .. IMG_H,
            color = BreitbandGraphics.colors.black,
        })
        BreitbandGraphics.draw_image2({
            path = peppers_path,
            destx1 = x,
            desty1 = y + LABEL_H,
            destx2 = x + IMG_W,
            desty2 = y + LABEL_H + IMG_H,
        })
    end

    do
        local x, y = COL3_X, ROW1_Y
        ugui.label({
            uid = 3,
            rectangle = {x = x, y = y, width = IMG_W, height = LABEL_H},
            text = '3. Source crop (top-left quarter)',
            color = BreitbandGraphics.colors.black,
        })
        local half_w = math.floor(info.width / 2)
        local half_h = math.floor(info.height / 2)
        BreitbandGraphics.draw_image2({
            path = peppers_path,
            destx1 = x,
            desty1 = y + LABEL_H,
            destx2 = x + IMG_W,
            desty2 = y + LABEL_H + IMG_H,
            srcx1 = 0,
            srcy1 = 0,
            srcx2 = half_w,
            srcy2 = half_h,
        })
    end

    do
        local x, y = COL1_X, ROW2_Y
        ugui.label({
            uid = 4,
            rectangle = {x = x, y = y, width = IMG_W, height = LABEL_H},
            text = '4. Red tint',
            color = BreitbandGraphics.colors.black,
        })
        BreitbandGraphics.draw_image2({
            path = peppers_path,
            destx1 = x,
            desty1 = y + LABEL_H,
            destx2 = x + IMG_W,
            desty2 = y + LABEL_H + IMG_H,
            color = {r = 255, g = 80, b = 80},
        })
    end

    do
        local x, y = COL2_X, ROW2_Y
        ugui.label({
            uid = 5,
            rectangle = {x = x, y = y, width = IMG_W, height = LABEL_H},
            text = '5. Nearest-neighbor interp (0)',
            color = BreitbandGraphics.colors.black,
        })
        BreitbandGraphics.draw_image2({
            path = peppers_path,
            destx1 = x,
            desty1 = y + LABEL_H,
            destx2 = x + IMG_W,
            desty2 = y + LABEL_H + IMG_H,
            srcx1 = 64,
            srcy1 = 64,
            srcx2 = 96,
            srcy2 = 96,
            interpolation = 0,
        })
    end

    do
        local x, y = COL3_X, ROW2_Y
        ugui.label({
            uid = 6,
            rectangle = {x = x, y = y, width = IMG_W, height = LABEL_H},
            text = '6. Linear interp (1)',
            color = BreitbandGraphics.colors.black,
        })
        BreitbandGraphics.draw_image2({
            path = peppers_path,
            destx1 = x,
            desty1 = y + LABEL_H,
            destx2 = x + IMG_W,
            desty2 = y + LABEL_H + IMG_H,
            srcx1 = 64,
            srcy1 = 64,
            srcx2 = 96,
            srcy2 = 96,
            interpolation = 1,
        })
    end

    end_frame()
end)
