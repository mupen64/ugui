--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@alias UguiClipboardGetDelegate fun(): string?
---A delegate function that gets the clipboard value, or `nil` if the clipboard is empty.

---@alias UguiClipboardSetDelegate fun(value: string)
---A delegate function that sets the clipboard value.

---@class UguiClipboard
---@field get UguiClipboardGetDelegate
---@field set UguiClipboardSetDelegate
---A class that provides clipboard access.
