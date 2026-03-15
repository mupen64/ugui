--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@class UguiStaticEnvironment
---@field clipboard UguiClipboard? The clipboard access provider.
---The script's environment that provides access to external facilities.

ugui.STATIC_ENV = {
    clipboard = {
        get = function() end,
        set = function(text) end,
    },
}
