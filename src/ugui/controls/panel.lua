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
---@return nil, Meta # Nothing.
ugui.panel = function(control)
    local result = ugui.control(control, 'panel')
    return result.primary, result.meta
end
