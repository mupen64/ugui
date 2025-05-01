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




return ugui