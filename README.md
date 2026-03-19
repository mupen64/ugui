<p align="center">
  <img width="128" align="center" src="https://github.com/mupen64/ugui/blob/main/assets/ugui.png?raw=true">
</p>

<div align="center">

# ugui

Flexible immediate-mode GUI library for Lua

</div>

## 🚀 Quickstart

Download `breitbandgraphics-amalgamated.lua` and `ugui-amalgamated.lua` from the latest [release](https://github.com/mupen64/ugui/releases/latest) and place them anywhere in your project.

Then call `dofile` for them with their absolute paths:

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

## 🛠️ Building from source

The `breitbandgraphics-amalgamated.lua` and `ugui-amalgamated.lua` files are both built via the `build.py` python script.

Requirements:
- Python >= 3.9 ([official download site](https://www.python.org/downloads/))
- git bash (as included in [Git for Windows](https://git-scm.com/install/windows))

Build steps:
1. Open a git bash, then clone the repository and navigate into the repository via the following command:
```bash
git clone https://github.com/mupen64/ugui.git && cd ./ugui
```
2. Create a python virtual environment and activate it:
```bash
python -m venv ./.venv
source ./.venv/Scripts/activate
```
> Note: The second line must be executed in each new terminal session in order to build.

3. Install dependencies:
```bash
pip install -r requirements.txt
```
4. Run the build script:
```
python build.py
```

That's it.  
`breitbandgraphics-amalgamated.lua` and `ugui-amalgamated.lua` should now have been created in the `./build/` directory.

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
