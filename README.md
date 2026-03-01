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

Read the [demo scripts](https://github.com/mupen64/ugui/tree/main/demos) and function documentation for usage information.

# 📈 Advantages

- Easy Usage
  - Immediate-mode control spawning API
- Flexible
  - Add or extend controls
  - Add or extend stylers
  - Mock subsystems
- Host-authoritative
  - Invokable anytime and anywhere
  - No global pollution - only necessary components are exposed as tables
- Fast
  - Shallow callstacks
  - Reduced indirection
  - Controls optimized for large datasets

# ✨ Features

<img width="28" align="left" src="https://github.com/mupen64/ugui/blob/main/assets/ugui.png?raw=true">

ugui  —  The GUI library

- Built-in stylers
  - Windows 10
  - Nineslice
- Flexibility
  - Modify any part of the framework to your liking
- User Productivity
  - Controls behave like Windows controls, ensuring consistency
- Button
- TextBox
  - Full-fledged selection and editing system
- ToggleButton
- CarrouselButton
- Joystick
  - Adjustable magnitude circle 
- TrackBar
  - Automatic layout adjustement based on size ratio 
- ComboBox
- ListBox
  - Scrolling support
  - Unlimited items with no performance degradation
- Scrollbar
- Menu
  - Unlimited child items and tree depth
  - Checkable items
- Single-Pass Layout System
- StackPanel
  - Horizontal/Vertical stacking
  - Element gap size
- Spinner
- NumberBox
- TabControl
- Performance
  - Graphics caching extension

<img width="28" align="left" src="https://github.com/mupen64/ugui/blob/main/assets/breitbandgraphics.png?raw=true">

BreitbandGraphics  —  ugui's rendering core

- Powerful abstraction layer over Mupen Lua drawing APIs
- Maximized usability
  - Stable API surface
- Helpful utilities
  - Hexadecimal color conversion
  - Standard color tables
- Low overhead
