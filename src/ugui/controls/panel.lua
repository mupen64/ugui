--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class Panel : Control
---An inert control used mostly as a container for other controls.

---@type ControlRegistryEntry
ugui.registry.panel = {}

---Places a Panel.
---@param control Panel The control table.
---@param fn ContentSlotCallback? The content slot callback.
---@return nil, Meta # Nothing.
ugui.panel = function(control, fn)
    local result = ugui.control(control, 'panel', fn)
    return result.primary, result.meta
end
