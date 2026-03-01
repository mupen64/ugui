--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---@alias UID number
---Unique identifier for a control. Must be unique within a frame.

---@alias RichText string
---Text which can contain other inline elements, such as icons.
---
---Examples:
---
---    [icon:arrow_left] Go Back
---    Move up [icon:arrow_up]
---    Down [icon:arrow_down:#FFFF00]
---    [icon:arrow_right:textbox.selection] Go Forward
---    Hello World!

---@alias RichTextSegment { type: ["text"|"icon"], value: string, color: string? }
---Represents a computed segment from a rich text string.

---@class UguiKeyEventArgs
---@field keycode UguiVKeycodes? The virtual keycode, if the event is a key event.
---@field pressed boolean? Whether the key was pressed or released, if the event is a key event.
---@field text string? The typed character, if the event is a char event and the key corresponds to a character.

---@class Environment
---@field public mouse_position { x: number, y: number } The mouse position.
---@field public wheel number The mouse wheel delta.
---@field public is_primary_down boolean? Whether the primary mouse button is being pressed.
---@field public key_events UguiKeyEventArgs[] The key events that happened since the last frame.
---@field public window_size { x: number, y: number }? The rendering bounds. If nil, no rendering bounds are considered and certain controls, such as menus, might overflow off-screen.

---@class Control
---@field public uid UID The unique identifier of the control.
---@field public styler_mixin any? An optional styler mixin table which can override specific styler parameters for this control.
---@field public rectangle Rectangle The rectangle in which the control is drawn.
---@field public is_enabled boolean? Whether the control is enabled. If nil or true, the control is enabled.
---@field public tooltip string? The control's tooltip. If nil, no tooltip will be shown.
---@field public plaintext boolean? Whether the control's text content is drawn as plain text without rich rendering.
---@field public z_index integer? The control's Z-index. If nil, `0` is assumed.
---The base class for all controls.

---@class Button : Control
---@field public text RichText The text displayed on the button.
---A button which can be clicked.

---@class ToggleButton : Button
---@field public is_checked boolean? Whether the button is checked. If nil, the ToggleButton is considered unchecked.
---A button which can be toggled on and off.

---@class CarrouselButton : Control
---@field public items string[] The items contained in the carrousel button.
---@field public selected_index integer The index of the currently selected item into the items array.
---A button which can be toggled on and off.
---TODO: Make wraparound optional

---@class TextBox : Control
---@field public text string The text contained in the textbox.
---A textbox which can be edited.

---@class Joystick : Control
---@field public position Vector2 The joystick's position with the range 0-128 on both axes.
---@field public mag number? The joystick's magnitude circle radius with the range `0-128`. If nil, no magnitude circle will be drawn.
---@field public x_snap integer? The snap distance to 0 on the X axis. If nil, no snap will be applied.
---@field public y_snap integer? The snap distance to 0 on the Y axis. If nil, no snap will be applied.
---A joystick which can be interacted with.

---@class Trackbar : Control
---@field public value number The current value in the range 0-1.
---A trackbar which can have its value adjusted.

---@class ComboBox : Control
---@field public items RichText[] The items contained in the control.
---@field public selected_index integer? The index of the currently selected item into the items array. If nil, no item is selected.
---A combobox which allows the user to choose from a list of items.

---@class ListBox : Control
---@field public items RichText[] The items contained in the control.
---@field public selected_index integer? The index of the currently selected item into the items array.
---@field public horizontal_scroll boolean? Whether horizontal scrolling will be enabled when items go beyond the width of the control. Will impact performance greatly, use with care.
---A listbox which allows the user to choose from a list of items.
---If the items don't fit in the control's bounds vertically, vertical scrolling will be enabled.
---If the items don't fit in the control's bounds horizontally, horizontal scrolling will be enabled if horizontal_scroll is true.
---The `rectangle` field might be mutated to accommodate the scrollbars.

---@class ScrollBar : Control
---@field public value number The scroll proportion in the range 0-1.
---@field public ratio number The overflow ratio, which is calculated by dividing the desired content dimensions by the relevant attached control's (e.g.: a listbox's) dimensions.
---A scrollbar which allows scrolling horizontally or vertically, depending on the control's dimensions.

---@class MenuItem
---@field public items MenuItem[]? The item's child items. If nil or empty, the item has no child items and is clickable.
---@field public enabled boolean? Whether the item is enabled. If nil or true, the item is enabled.
---@field public checked boolean? Whether the item is checked. If true, the item is checked.
---@field public text RichText The item's text.
---Represents an item inside of a Menu.

---@class MenuResult
---@field public item MenuItem? The item that was clicked, or nil if none was.
---@field public dismissed boolean Whether the menu was dismissed by clicking outside of it.

---@class Menu : Control
---@field public items MenuItem[] The items contained in the menu.
---A menu, which allows the user to choose from a list of items.

---@class ToolTip
---@field public text RichText The tooltip's text.
---A tooltip, which can be used to show additional information about a control.

---@class Spinner : Control
---@field public value number The spinner's numerical value.
---@field public increment number? The increment applied when the + or - buttons are clicked (negated when - is clicked). If nil, 1 is assumed.
---@field public minimum_value number? The minimum value.
---@field public maximum_value number? The maximum value.
---@field public is_horizontal boolean? Whether the increment buttons are stacked horizontally.
---A spinner, consisting of a textbox and buttons for incrementing or decrementing a number.

---@class TabControl : Control
---@field public items RichText[] The tab headers.
---@field public selected_index integer The index of the currently selected tab.
---A tab control, which allows the user to choose from a list of tabs.

---@class TabControlResult
---@field public selected_index integer The index of the selected tab.
---@field public rectangle Rectangle The visual bounds the selected tab can place its contents in.

---@class NumberBox : Control
---@field public value integer The value.
---@field public places integer The amount of digits the value is padded to.
---@field public show_negative boolean? Whether a button for viewing and toggling the value's sign is shown. If nil, false is assumed.
---A numberbox, which allows modifying a number by typing or by adjusting its individual digits.

---@class Meta
---@field public signal_change SignalChangeState The change state of the control's primary signal.
---Additional information about a placed control.

---@alias ControlType "button" | "toggle_button" | "carrousel_button" | "textbox" | "joystick" | "trackbar" | "listbox" | "scrollbar" | "combobox" | "menu" | "numberbox"

---@alias ControlReturnValue { primary: any, meta: Meta }

---@class ControlRegistryEntry
---@field public validate fun(control: Control) Verifies that a control instance matches the desired type.
---@field public setup fun(control: Control, data: any)? Sets up the initial control data to be used in `logic` and `draw`.
---@field public added fun(control: Control, data: any)? Notifies about a control being added to a scene.
---@field public logic fun(control: Control, data: any): ControlReturnValue Executes control logic.
---@field public draw fun(control: Control) Draws the control.
---Represents an entry in the control registry.


---@enum VisualState
-- The possible states of a control, which are used by the styler for drawing.
ugui.visual_states = {
    --- The control doesn't accept user interactions.
    disabled = 0,
    --- The control isn't being interacted with.
    normal = 1,
    --- The mouse is over the control.
    hovered = 2,
    --- The control is currently capturing inputs.
    active = 3,
}

---@enum SignalChangeState
--- The change in the primary signal ("return value") of a control.
ugui.signal_change_states = {
    --- The signal isn't changing.
    none = 0,
    --- The signal has just started changing.
    started = 1,
    --- The signal is currently changing.
    ongoing = 2,
    --- The signal has just stopped changing.
    ended = 3,
}

---@enum UguiVKeycodes
-- A complete enum of Virtual-Key codes.
ugui.keycodes = {
    -- Mouse Buttons
    VK_LBUTTON = 0x01,  -- Left mouse button
    VK_RBUTTON = 0x02,  -- Right mouse button
    VK_CANCEL = 0x03,   -- Control-break processing
    VK_MBUTTON = 0x04,  -- Middle mouse button
    VK_XBUTTON1 = 0x05, -- X1 mouse button
    VK_XBUTTON2 = 0x06, -- X2 mouse button
    -- 0x07 Reserved

    -- Editing/Navigation
    VK_BACK = 0x08,   -- Backspace key
    VK_TAB = 0x09,    -- Tab key
    -- 0x0A–0x0B Reserved
    VK_CLEAR = 0x0C,  -- Clear key
    VK_RETURN = 0x0D, -- Enter key
    -- 0x0E–0x0F Unassigned

    -- Modifier and Lock Keys
    VK_SHIFT = 0x10,   -- Shift key
    VK_CONTROL = 0x11, -- Ctrl key
    VK_MENU = 0x12,    -- Alt (Menu) key
    VK_PAUSE = 0x13,   -- Pause key
    VK_CAPITAL = 0x14, -- Caps Lock key

    -- IME and Language
    VK_KANA = 0x15,    -- IME Kana mode
    VK_HANGUL = 0x15,  -- IME Hangul mode (same value)
    VK_IME_ON = 0x16,  -- IME On
    VK_JUNJA = 0x17,   -- IME Junja mode
    VK_FINAL = 0x18,   -- IME final mode
    VK_HANJA = 0x19,   -- IME Hanja mode
    VK_KANJI = 0x19,   -- IME Kanji mode (same value)
    VK_IME_OFF = 0x1A, -- IME Off

    -- Navigation/System
    VK_ESCAPE = 0x1B,     -- Esc key
    VK_CONVERT = 0x1C,    -- IME Convert
    VK_NONCONVERT = 0x1D, -- IME Non-convert
    VK_ACCEPT = 0x1E,     -- IME Accept
    VK_MODECHANGE = 0x1F, -- IME Mode change request
    VK_SPACE = 0x20,      -- Spacebar
    VK_PRIOR = 0x21,      -- Page Up
    VK_NEXT = 0x22,       -- Page Down
    VK_END = 0x23,        -- End
    VK_HOME = 0x24,       -- Home
    VK_LEFT = 0x25,       -- Left arrow
    VK_UP = 0x26,         -- Up arrow
    VK_RIGHT = 0x27,      -- Right arrow
    VK_DOWN = 0x28,       -- Down arrow
    VK_SELECT = 0x29,     -- Select key
    VK_PRINT = 0x2A,      -- Print key
    VK_EXECUTE = 0x2B,    -- Execute key
    VK_SNAPSHOT = 0x2C,   -- Print Screen key
    VK_INSERT = 0x2D,     -- Insert key
    VK_DELETE = 0x2E,     -- Delete key
    VK_HELP = 0x2F,       -- Help key

    -- Number Keys (0–9)
    VK_0 = 0x30, -- '0' key
    VK_1 = 0x31, -- '1' key
    VK_2 = 0x32, -- '2' key
    VK_3 = 0x33, -- '3' key
    VK_4 = 0x34, -- '4' key
    VK_5 = 0x35, -- '5' key
    VK_6 = 0x36, -- '6' key
    VK_7 = 0x37, -- '7' key
    VK_8 = 0x38, -- '8' key
    VK_9 = 0x39, -- '9' key
    -- 0x3A–0x40 Undefined

    -- Letter Keys (A–Z)
    VK_A = 0x41, -- A key
    VK_B = 0x42, -- B key
    VK_C = 0x43, -- C key
    VK_D = 0x44, -- D key
    VK_E = 0x45, -- E key
    VK_F = 0x46, -- F key
    VK_G = 0x47, -- G key
    VK_H = 0x48, -- H key
    VK_I = 0x49, -- I key
    VK_J = 0x4A, -- J key
    VK_K = 0x4B, -- K key
    VK_L = 0x4C, -- L key
    VK_M = 0x4D, -- M key
    VK_N = 0x4E, -- N key
    VK_O = 0x4F, -- O key
    VK_P = 0x50, -- P key
    VK_Q = 0x51, -- Q key
    VK_R = 0x52, -- R key
    VK_S = 0x53, -- S key
    VK_T = 0x54, -- T key
    VK_U = 0x55, -- U key
    VK_V = 0x56, -- V key
    VK_W = 0x57, -- W key
    VK_X = 0x58, -- X key
    VK_Y = 0x59, -- Y key
    VK_Z = 0x5A, -- Z key

    -- Windows/Apps Keys
    VK_LWIN = 0x5B,  -- Left Windows key
    VK_RWIN = 0x5C,  -- Right Windows key
    VK_APPS = 0x5D,  -- Applications key
    -- 0x5E Reserved
    VK_SLEEP = 0x5F, -- Computer Sleep key

    -- Numeric Keypad
    VK_NUMPAD0 = 0x60,   -- Numpad 0
    VK_NUMPAD1 = 0x61,   -- Numpad 1
    VK_NUMPAD2 = 0x62,   -- Numpad 2
    VK_NUMPAD3 = 0x63,   -- Numpad 3
    VK_NUMPAD4 = 0x64,   -- Numpad 4
    VK_NUMPAD5 = 0x65,   -- Numpad 5
    VK_NUMPAD6 = 0x66,   -- Numpad 6
    VK_NUMPAD7 = 0x67,   -- Numpad 7
    VK_NUMPAD8 = 0x68,   -- Numpad 8
    VK_NUMPAD9 = 0x69,   -- Numpad 9
    VK_MULTIPLY = 0x6A,  -- Numpad *
    VK_ADD = 0x6B,       -- Numpad +
    VK_SEPARATOR = 0x6C, -- Separator key
    VK_SUBTRACT = 0x6D,  -- Numpad –
    VK_DECIMAL = 0x6E,   -- Numpad .
    VK_DIVIDE = 0x6F,    -- Numpad /

    -- Function Keys
    VK_F1 = 0x70,
    VK_F2 = 0x71,
    VK_F3 = 0x72,
    VK_F4 = 0x73,
    VK_F5 = 0x74,
    VK_F6 = 0x75,
    VK_F7 = 0x76,
    VK_F8 = 0x77,
    VK_F9 = 0x78,
    VK_F10 = 0x79,
    VK_F11 = 0x7A,
    VK_F12 = 0x7B,
    VK_F13 = 0x7C,
    VK_F14 = 0x7D,
    VK_F15 = 0x7E,
    VK_F16 = 0x7F,
    VK_F17 = 0x80,
    VK_F18 = 0x81,
    VK_F19 = 0x82,
    VK_F20 = 0x83,
    VK_F21 = 0x84,
    VK_F22 = 0x85,
    VK_F23 = 0x86,
    VK_F24 = 0x87,
    -- 0x88–0x8F Reserved

    -- Lock Keys & OEM
    VK_NUMLOCK = 0x90, -- Num Lock
    VK_SCROLL = 0x91,  -- Scroll Lock
    -- 0x92–0x96 OEM specific
    -- 0x97–0x9F Unassigned

    -- Extended Modifiers
    VK_LSHIFT = 0xA0,   -- Left Shift
    VK_RSHIFT = 0xA1,   -- Right Shift
    VK_LCONTROL = 0xA2, -- Left Ctrl
    VK_RCONTROL = 0xA3, -- Right Ctrl
    VK_LMENU = 0xA4,    -- Left Alt
    VK_RMENU = 0xA5,    -- Right Alt

    -- Multimedia & Browser Keys (extended range)
    VK_BROWSER_BACK = 0xA6,        -- Browser Back
    VK_BROWSER_FORWARD = 0xA7,     -- Browser Forward
    VK_BROWSER_REFRESH = 0xA8,     -- Browser Refresh
    VK_BROWSER_STOP = 0xA9,        -- Browser Stop
    VK_BROWSER_SEARCH = 0xAA,      -- Browser Search
    VK_BROWSER_FAVORITES = 0xAB,   -- Browser Favorites
    VK_BROWSER_HOME = 0xAC,        -- Browser Home
    VK_VOLUME_MUTE = 0xAD,         -- Volume Mute
    VK_VOLUME_DOWN = 0xAE,         -- Volume Down
    VK_VOLUME_UP = 0xAF,           -- Volume Up
    VK_MEDIA_NEXT_TRACK = 0xB0,    -- Media Next Track
    VK_MEDIA_PREV_TRACK = 0xB1,    -- Media Previous Track
    VK_MEDIA_STOP = 0xB2,          -- Media Stop
    VK_MEDIA_PLAY_PAUSE = 0xB3,    -- Media Play/Pause
    VK_LAUNCH_MAIL = 0xB4,         -- Launch Mail
    VK_LAUNCH_MEDIA_SELECT = 0xB5, -- Media Select
    VK_LAUNCH_APP1 = 0xB6,         -- Launch App1
    VK_LAUNCH_APP2 = 0xB7,         -- Launch App2
    -- 0xB8–0xB9 Reserved

    -- OEM Specific and Other
    VK_OEM_1 = 0xBA,      -- ';:' key
    VK_OEM_PLUS = 0xBB,   -- '+' key
    VK_OEM_COMMA = 0xBC,  -- ',' key
    VK_OEM_MINUS = 0xBD,  -- '-' key
    VK_OEM_PERIOD = 0xBE, -- '.' key
    VK_OEM_2 = 0xBF,      -- '/?' key
    VK_OEM_3 = 0xC0,      -- '`~' key
    -- 0xC1–0xD7 Reserved
    -- 0xD8–0xDA Unassigned
    VK_OEM_4 = 0xDB, -- '[{' key
    VK_OEM_5 = 0xDC, -- '\|' key
    VK_OEM_6 = 0xDD, -- ']}' key
    VK_OEM_7 = 0xDE, -- '\''/'"' key
    VK_OEM_8 = 0xDF, -- Miscellaneous
    -- 0xE0 Reserved
    -- 0xE1 OEM specific
    VK_OEM_102 = 0xE2,    -- Angle bracket or backslash (RT 102-key)
    VK_PROCESSKEY = 0xE5, -- IME Process key
    -- 0xE6 OEM specific
    VK_PACKET = 0xE7,     -- Unicode packet key
    -- 0xE8 Unassigned
    -- 0xE9–0xF5 OEM specific
    VK_ATTN = 0xF6,      -- Attn key
    VK_CRSEL = 0xF7,     -- CRSEL key
    VK_EXSEL = 0xF8,     -- EXSEL key
    VK_EREOF = 0xF9,     -- Erase EOF key
    VK_PLAY = 0xFA,      -- Play key
    VK_ZOOM = 0xFB,      -- Zoom key
    VK_NONAME = 0xFC,    -- Reserved
    VK_PA1 = 0xFD,       -- PA1 key
    VK_OEM_CLEAR = 0xFE, -- Clear key
}

---@alias SceneEntry { control: Control, type: ControlType }

---@class TextBoxNavigationKeyProcessingResult
---@field public handled boolean Whether the key press was handled.
---@field public text string? The new textbox text.
---@field public selection_start integer? The new textbox selection start index.
---@field public selection_end integer? The new textbox selection end index.
---@field public caret_index integer? The new textbox caret index.
