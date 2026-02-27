--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

local ugui = {
    _VERSION = 'v3.0.3',
    _URL = 'https://github.com/Aurumaker72/mupen-lua-ugui',
    _DESCRIPTION = 'Flexible immediate-mode GUI library for Mupen Lua',
    _LICENSE = 'GPL-3',
    DEBUG = false,
}

if not BreitbandGraphics then
    error('BreitbandGraphics must be present in the global scope as \'BreitbandGraphics\' prior to executing ugui', 0)
    return
end
