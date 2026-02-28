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

---@class Environment
---@field public mouse_position { x: number, y: number } The mouse position.
---@field public wheel number The mouse wheel delta.
---@field public is_primary_down boolean? Whether the primary mouse button is being pressed.
---@field public held_keys table<string, boolean> A map of held key identifiers to booleans. A key not being present or its value being 'false' means it is not held.
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

---@alias SceneEntry { control: Control, type: ControlType }

---@class TextBoxNavigationKeyProcessingResult
---@field public handled boolean Whether the key press was handled.
---@field public text string? The new textbox text.
---@field public selection_start integer? The new textbox selection start index.
---@field public selection_end integer? The new textbox selection end index.
---@field public caret_index integer? The new textbox caret index.
