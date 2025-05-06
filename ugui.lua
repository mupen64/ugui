local ugui = {
    _VERSION = 'v0.0.1',
    _URL = 'https://github.com/Aurumaker72/mupen-lua-ugui',
    _DESCRIPTION = 'Flexible immediate-mode GUI library for Mupen Lua',
    _LICENSE = 'GPL-3',
}

if not BreitbandGraphics then
    error('BreitbandGraphics must be present in the global scope as \'BreitbandGraphics\' prior to executing ugui', 0)
    return
end

--#region Types

---@enum LayoutAlignment
ugui.ALIGNMENTS = {
    start = 1,
    center = 2,
    ['end'] = 3,
    stretch = 4,
}

---@alias ClassId number

---@class ControlClass
---@field name string The class name.
---@field measure fun(self: InternalControl): Vector2 Returns the control's desired size. Class implementations should only call this via [ugui.internal.call_measure](lua://ugui.internal.call_measure).
---@field arrange fun(self: InternalControl): Rectangle[] Returns the desired layout bounds for the control's children.
---@field paint fun(self: InternalControl, bounds: Rectangle)
---Represents a control's prototype.

---@class Control
---@field class ClassId
---@field x_align LayoutAlignment?
---@field y_align LayoutAlignment?
---@field margin Margin?
---Represents a control.

---@package
---@class InternalControl: Control
---@field parent InternalControl The parent.
---@field children InternalControl[] The control's children.
---@field desired_size Vector2 The control's desired layout size.
---@field render_bounds Rectangle
---@field image number The control's rendered texture.
---The framework's internal control representation.

---@alias Margin { [1]: number, [2]: number, [3]: number, [4]: number }
---Left, Top, Right, Bottom

--#endregion

--#region Internal API

ugui.internal = {
    ---@type InternalControl
    root = nil,

    ---@type Vector2
    prev_available_size = {x = 0, y = 0},

    ---@type Vector2
    available_size = {x = 0, y = 0},

    ---@type { [ClassId]: ControlClass }
    ---The control registry. Associates a control
    classes = {},

    ---@type InternalControl[]
    layout_queue = {},

    ---@type InternalControl[]
    visual_queue = {},
}

function ugui.internal.handle_window_sizing()
    local size = wgui.info()
    ugui.internal.prev_available_size = {x = ugui.internal.available_size.x, y = ugui.internal.available_size.y}
    ugui.internal.available_size = {x = size.width, y = size.height}

    if ugui.internal.available_size.x ~= ugui.internal.prev_available_size.x or ugui.internal.available_size.y ~= ugui.internal.prev_available_size.y then
        ugui.invalidate_layout(ugui.internal.root)
        ugui.invalidate_visual(ugui.internal.root)
    end
end

---Aligns rect1 inside rect2 by the specified alignments.
---@param rect1 Rectangle
---@param rect2 Rectangle
---@param x_align LayoutAlignment
---@param y_align LayoutAlignment
---@return Rectangle
function ugui.internal.align_rect(rect1, rect2, x_align, y_align)
    local out = {x = rect1.x, y = rect1.y, width = rect1.width, height = rect1.height}

    if x_align == ugui.ALIGNMENTS.start then
        out.x = rect2.x
    elseif x_align == ugui.ALIGNMENTS.center then
        out.x = rect2.x + (rect2.width - out.width) / 2
    elseif x_align == ugui.ALIGNMENTS['end'] then
        out.x = rect2.x + rect2.width - out.width
    else
        out.x = rect2.x
        out.width = rect2.width
    end

    if y_align == ugui.ALIGNMENTS.start then
        out.y = rect2.y
    elseif y_align == ugui.ALIGNMENTS.center then
        out.y = rect2.y + (rect2.height - out.height) / 2
    elseif y_align == ugui.ALIGNMENTS['end'] then
        out.y = rect2.y + rect2.height - out.height
    else
        out.y = rect2.y
        out.height = rect2.height
    end

    return out
end

function ugui.internal.do_layout()
    local function apply_margin(control, rect)
        rect.x = rect.x + control.margin[1]
        rect.y = rect.y + control.margin[2]
    end
    local window_rect = {x = 0, y = 0, width = ugui.internal.available_size.x, height = ugui.internal.available_size.y}

    for _, control in pairs(ugui.internal.layout_queue) do
        ugui.internal.foreach_child(control, function(control, class)
            control.desired_size = ugui.internal.call_measure(control)

            local parent_render_bounds = control.parent and control.parent.render_bounds or window_rect
            control.render_bounds = ugui.internal.align_rect({x = 0, y = 0, width = control.desired_size.x, height = control.desired_size.y}, parent_render_bounds, control.x_align, control.y_align)
            apply_margin(control, control.render_bounds)
        end)
    end

    for _, control in pairs(ugui.internal.layout_queue) do
        ugui.internal.foreach_child(control, function(control, class)
            local child_bounds = class.arrange(control)
            assert(#child_bounds == #control.children)

            -- Results from arrange() are control-relative
            for _, rect in pairs(child_bounds) do
                rect.x = control.render_bounds.x + rect.x
                rect.y = control.render_bounds.y + rect.y
            end

            for i, child in pairs(control.children) do
                child.render_bounds = ugui.internal.align_rect({x = 0, y = 0, width = child.desired_size.x, height = child.desired_size.y}, child_bounds[i], child.x_align, child.y_align)
                apply_margin(child, child.render_bounds)
            end
        end)
    end

    ugui.internal.layout_queue = {}
end

function ugui.internal.do_render()
    for _, control in pairs(ugui.internal.visual_queue) do
        ugui.internal.foreach_child(control, function(control, class)
            control.image = d2d.draw_to_image(control.render_bounds.width, control.render_bounds.height, function()
                class.paint(control, {x = 0, y = 0, width = control.render_bounds.width, height = control.render_bounds.height})
            end)
        end)
    end

    d2d.clear(0, 0, 0, 0)
    ugui.internal.foreach_child(ugui.internal.root, function(control)
        local dest_rect = control.render_bounds

        local src_rect = {
            x = 0,
            y = 0,
            width = control.render_bounds.width,
            height = control.render_bounds.height,
        }

        d2d.draw_image(
            dest_rect.x,
            dest_rect.y,
            dest_rect.x + dest_rect.width,
            dest_rect.y + dest_rect.height,
            src_rect.x,
            src_rect.y,
            src_rect.x + src_rect.width,
            src_rect.y + src_rect.height,
            255,
            1,
            control.image)
    end)

    ugui.internal.visual_queue = {}
end

---Performs a system tick.
function ugui.internal.tick()
    ugui.internal.handle_window_sizing()

    ugui.internal.do_layout()
    ugui.internal.do_render()
end

---Gets the class for the specified control.
---@param control InternalControl
---@return ControlClass #
function ugui.internal.get_class(control)
    local class = ugui.internal.classes[control.class]

    if not class then
        error(string.format("Couldn't find registered class named '%s'", control.class))
    end

    return class
end

---Iterates over a control and all its children.
---@param control InternalControl The control.
---@param callback fun(control: InternalControl, class: ControlClass): boolean? The iterator callback. Returns `false` if the iteration should be cancelled.
function ugui.internal.foreach_child(control, callback)
    if callback(control, ugui.internal.get_class(control)) == false then
        return
    end

    for i = 1, #control.children, 1 do
        local child = control.children[i]
        ---@cast child InternalControl

        if callback(child, ugui.internal.get_class(child)) == false then
            break
        end

        ugui.internal.foreach_child(child, callback)
    end
end

---Calls a control's `measure` implementation and applies margins. Must be used instead of a direct call to `measure`.
---@param control InternalControl
function ugui.internal.call_measure(control)
    local desired_size = ugui.internal.get_class(control).measure(control)

    desired_size.x = desired_size.x + control.margin[1] + control.margin[3]
    desired_size.y = desired_size.y + control.margin[2] + control.margin[4]

    return desired_size
end

---Default `measure` implementation which returns the size of the biggest child.
---@param self InternalControl
function ugui.internal.measure_max_child_size(self)
    local desired_size = {x = 0, y = 0}
    for _, child in pairs(self.children) do
        local size = ugui.internal.call_measure(child)
        if size.x > desired_size.x then
            desired_size.x = size.x
        end
        if size.y > desired_size.y then
            desired_size.y = size.y
        end
    end

    return desired_size
end

---Default `arrange` implementation which gives children the size of the parent.
---@param self InternalControl
function ugui.internal.arrange_fill(self)
    local bounds = {}

    for _, child in pairs(self.children) do
        bounds[#bounds + 1] = {
            x = 0,
            y = 0,
            width = self.desired_size.x,
            height = self.desired_size.y,
        }
    end

    return bounds
end

---Gets a list of a control's parents up to the root.
---@param control InternalControl
---@return InternalControl[]
function ugui.internal.get_parents(control)
    local parents = {}
    local current = control.parent

    while current do
        parents[#parents + 1] = current
        current = current.parent
    end

    return parents
end

---Returns whether any parent of the control (up to the root) or the control itself is present in the specified list.
---@param control InternalControl
---@param list InternalControl[]
function ugui.internal.is_any_parent_or_self_in_list(control, list)
    local parents = ugui.internal.get_parents(control)
    for _, existing in pairs(list) do
        if existing == control then
            return true
        end
        for _, parent in pairs(parents) do
            if parent == existing then
                return true
            end
        end
    end
    return false
end

--#endregion

--#region Public API

---Registers a control class with the specified id.
---@param id ClassId
---@param class ControlClass
function ugui.register(id, class)
    ugui.internal.classes[id] = class
end

---Adds the specified control to the parent.
---@param parent Control? The control's parent, or `nil` if the control should be treated as the root control.
---@param control Control The control to add.
function ugui.add(parent, control)
    ---@cast control InternalControl
    ---@cast parent InternalControl

    control.x_align = control.x_align or ugui.ALIGNMENTS.center
    control.y_align = control.y_align or ugui.ALIGNMENTS.center
    control.margin = control.margin or {0, 0, 0, 0}
    control.parent = parent
    control.children = {}
    control.desired_size = {x = 0, y = 0}
    control.image = 0

    if parent then
        parent.children[#parent.children + 1] = control
    else
        ugui.internal.root = control
    end

    ugui.invalidate_layout(control)
    ugui.invalidate_visual(control)

    return control
end

---Invalidates the layout of the specified control.
---@param control InternalControl
function ugui.invalidate_layout(control)
    if ugui.internal.is_any_parent_or_self_in_list(control, ugui.internal.layout_queue) then
        return
    end
    ugui.internal.layout_queue[#ugui.internal.layout_queue + 1] = control
end

---Invalidates the visuals of the specified control.
---@param control InternalControl
function ugui.invalidate_visual(control)
    if ugui.internal.is_any_parent_or_self_in_list(control, ugui.internal.visual_queue) then
        return
    end
    ugui.internal.visual_queue[#ugui.internal.visual_queue + 1] = control
end

function ugui.start()
    print('Starting ugui...')

    if not ugui.internal.root then
        error('Couldn\'t start ugui due to no root control being present.')
    end
    emu.atdrawd2d(ugui.internal.tick)
end

--#endregion

--#region Default Controls

ugui.PANEL = 0
ugui.TEXTBLOCK = 1
ugui.STACKPANEL = 2
ugui.BUTTON = 3

ugui.register(ugui.PANEL, {
    name = 'panel',
    measure = ugui.internal.measure_max_child_size,
    arrange = ugui.internal.arrange_fill,
    paint = function(self, bounds)
        BreitbandGraphics.draw_rectangle(bounds, BreitbandGraphics.colors.red, 1)
    end,
})

ugui.register(ugui.TEXTBLOCK, {
    name = 'textblock',
    measure = function(self)
        local desired_size = BreitbandGraphics.get_text_size(self.text, 20, 'MS Shell Dlg')
        return {x = desired_size.width + 1, y = desired_size.height}
    end,
    arrange = ugui.internal.arrange_fill,
    paint = function(self, bounds)
        BreitbandGraphics.draw_text2({
            text = self.text,
            rectangle = bounds,
            color = BreitbandGraphics.colors.red,
            font_name = 'MS Shell Dlg',
            font_size = 20,
            grayscale = true,
            fit = true,
        })
    end,
})

ugui.register(ugui.STACKPANEL, {
    name = 'stackpanel',
    measure = function(self)
        local desired_size = {x = 0, y = 0}

        for _, child in pairs(self.children) do
            local size = ugui.internal.call_measure(child)

            if size.x > desired_size.x then
                desired_size.x = size.x
            end

            desired_size.y = desired_size.y + size.y
        end

        return desired_size
    end,
    arrange = function(self)
        local bounds = {}

        local y = 0
        for _, child in pairs(self.children) do
            bounds[#bounds + 1] = {
                x = 0,
                y = y,
                width = self.desired_size.x,
                height = child.desired_size.y,
            }
            y = y + child.desired_size.y
        end

        return bounds
    end,
    paint = function(self, bounds)
        BreitbandGraphics.draw_rectangle(bounds, BreitbandGraphics.colors.blue, 1)
    end,
})

ugui.register(ugui.BUTTON, {
    name = 'button',
    measure = ugui.internal.measure_max_child_size,
    arrange = ugui.internal.arrange_fill,
    paint = function(self, bounds)
        BreitbandGraphics.draw_rectangle(bounds, BreitbandGraphics.colors.yellow, 1)
    end,
})

--#endregion

return ugui
