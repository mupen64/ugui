<p align="center">
  <img width="128" align="center" src="https://github.com/mupen64/ugui/blob/main/assets/ugui.png?raw=true">
</p>

<div align="center">

# ugui

Flexible immediate-mode GUI library for Lua

</div>

## 🚀 Quickstart

Download `breitbandgraphics-amalgamated.lua` and `ugui-amalgamated.lua` from the latest [release](https://github.com/mupen64/ugui/releases)
and place them anywhere in your repository. Then simply do the following in your main script file call `dofile` for them with their absolute file paths, for example:

```lua

-- Get the directory where your entry script file is located (Windows, includes trailing backslash)
folder = debug.getinfo(1).source:sub(2):match('(.*\\)')

---@module "breitbandgraphics-amalgamated"
BreitbandGraphics = dofile(folder .. 'breitbandgraphics-amalgamated.lua')

---@module "ugui-amalgamated"
ugui = dofile(folder .. 'ugui-amalgamated.lua')
```

That's it.  
Read the [demo scripts](https://github.com/mupen64/ugui/tree/main/demos) for usage examples.

## ✨ Features

### Control Suite

- `button`
- `carrousel_button`
- `combobox`
- `joystick`
- `label`
- `listbox`
  - Scrolling support
  - Unlimited items with no performance degradation
- `menu`
  - Checkable items
- `numberbox`
- `scrollbar`
- `spinner`
  - Optional negative/positive toggle
- `tabcontrol`
  - Adjustable magnitude circle 
- `textbox`
- `toggle_button`
- `trackbar`

### Rendering

Can render using a built-in Windows 10-like style, or with ninesliced images.

Depends on BreitbandGraphics for rendering, which is included in this repository as well ([see below](#breitbandgraphics)).

### Hackability

Any part of the library can be overwritten externally. Future compatibility not guaranteed.

---

<p align="center">
  <img width="128" align="center" src="https://github.com/mupen64/ugui/blob/main/assets/breitbandgraphics.png?raw=true">
</p>

<div align="center">

# BreitbandGraphics

The rendering abstraction

</div>

## Backends

Built-in backend for the [Mupen64](https://github.com/mupen64/mupen64-rr-lua) emulator.

## Utilities

Provides various utilities for color conversion and manipulation.
