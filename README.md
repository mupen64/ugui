<p align="center">
  <img width="128" align="center" src="https://github.com/mupen64/ugui/blob/main/assets/ugui.png?raw=true">
</p>


<h1 align="center">
  ugui
</h1>
<p align="center">
  Flexible immediate-mode GUI library for Lua
</p>

# 🚀 Quickstart

```lua
---@module "breitbandgraphics-amalgamated"
BreitbandGraphics = dofile('breitbandgraphics-amalgamated.lua')

---@module "ugui-amalgamated"
ugui = dofile('ugui-amalgamated.lua')
```

That's it. Don't forget to pass an absolute path, not a relative one.

Read the [demo scripts](https://github.com/mupen64/ugui/tree/main/demos) for usage examples.

# ✨ Features

<img width="28" align="left" src="https://github.com/mupen64/ugui/blob/main/assets/ugui.png?raw=true">

ugui  —  The GUI library

### Control Suite

- `button`
- `textbox`
- `toggle_button`
- `carrousel_button`
- `trackbar`
- `combobox`
- `listbox`
  - Scrolling support
  - Unlimited items with no performance degradation
- `scrollbar`
- `menu`
  - Checkable items
- `spinner`
  - Optional negative/positive toggle
- `numberbox`
- `tabcontrol`
- `joystick`
  - Adjustable magnitude circle 

### Rendering

Can render using a built-in Windows 10-like style, or with ninesliced images.

Depends on BreitbandGraphics for rendering.

### Hackability

Any part of the library can be overwritten externally. Future compatibility not guaranteed.

<img width="28" align="left" src="https://github.com/mupen64/ugui/blob/main/assets/breitbandgraphics.png?raw=true">

#

BreitbandGraphics  —  The rendering abstraction

### Backends

Built-in backend for the [Mupen64](https://github.com/mupen64/mupen64-rr-lua) emulator.

### Utilities

Provides various utilities for color conversion and manipulation.
