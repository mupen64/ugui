--
-- Copyright (c) 2026, Mupen64 maintainers.
--
-- SPDX-License-Identifier: GPL-3.0-or-later
--

---Asserts that the specified condition is true, printing the stacktrace if it's false.
---@param condition boolean
---@param message string
ugui.internal.assert = function(condition, message)
    if condition then
        return
    end
    print(debug.traceback())
    assert(condition, message)
end

---Deeply clones a table.
---@param obj table The table to clone.
---@param seen table? Internal. Pass nil as a caller.
---@return table A cloned instance of the table.
ugui.internal.deep_clone = function(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do
        res[ugui.internal.deep_clone(k, s)] = ugui.internal.deep_clone(
            v, s)
    end
    return res
end

---Merges two tables deeply, mutating the second table with the first table's values, giving precedence to the first table's values.
---@param a table The override table, whose values take precedence.
---@param b table The source and target table, mutated in-place.
---@return function A function that rolls back all changes made to b.
ugui.internal.deep_merge = function(a, b)
    local rollback_ops = {}

    local function merge(t1, t2)
        for key, value in pairs(t1) do
            if type(value) == 'table' and type(t2[key]) == 'table' then
                merge(value, t2[key])
            else
                local prev = t2[key]
                t2[key] = value
                local t2_ref = t2
                local k = key
                rollback_ops[#rollback_ops + 1] = function()
                    t2_ref[k] = prev
                end
            end
        end
    end

    merge(a, b)

    return function()
        for i = #rollback_ops, 1, -1 do
            rollback_ops[i]()
        end
    end
end

---Performs an in-place stable sort on the specified table.
---@generic T
---@param t T[]
---@param cmp? fun(a: T, b: T):boolean
ugui.internal.stable_sort = function(t, cmp)
    local function merge(left, right)
        local result = {}
        local i, j = 1, 1
        while i <= #left and j <= #right do
            -- If left < right, or they are "equal" (cmp false both ways),
            -- take from the left to preserve stability
            if cmp(left[i], right[j]) or (not cmp(right[j], left[i])) then
                table.insert(result, left[i])
                i = i + 1
            else
                table.insert(result, right[j])
                j = j + 1
            end
        end
        while i <= #left do
            table.insert(result, left[i])
            i = i + 1
        end
        while j <= #right do
            table.insert(result, right[j])
            j = j + 1
        end
        return result
    end

    local function mergesort(arr)
        if #arr <= 1 then
            return arr
        end
        local mid = math.floor(#arr / 2)
        local left, right = {}, {}
        for i = 1, mid do
            table.insert(left, arr[i])
        end
        for i = mid + 1, #arr do
            table.insert(right, arr[i])
        end
        return merge(mergesort(left), mergesort(right))
    end

    local sorted = mergesort(t)
    for i = 1, #t do
        t[i] = sorted[i]
    end
end

---Removes a range of characters from a string.
---@param string string The string to remove characters from.
---@param start_index integer The index of the first character to remove.
---@param end_index integer The index of the last character to remove.
---@return string # A new string with the characters removed.
ugui.internal.remove_range = function(string, start_index, end_index)
    if start_index > end_index then
        start_index, end_index = end_index, start_index
    end
    return string.sub(string, 1, start_index - 1) .. string.sub(string, end_index)
end

---Removes the character at the specified index from a string.
---@param string string The string to remove the character from.
---@param index integer The index of the character to remove.
---@return string # A new string with the character removed.
ugui.internal.remove_at = function(string, index)
    if index == 0 then
        return string
    end
    return string:sub(1, index - 1) .. string:sub(index + 1, string:len())
end

---Inserts a string into another string at the specified index.
---@param string string The original string to insert the other string into.
---@param string2 string The other string.
---@param index integer The index into the first string to begin inserting the second string at.
---@return string # A new string with the other string inserted.
ugui.internal.insert_at = function(string, string2, index)
    index = math.max(1, math.min(index, #string + 1))
    return string:sub(1, index - 1) .. string2 .. string:sub(index)
end

---Gets the digit at a specific index in a number with a specific padded length.
---@param value integer The number.
---@param length integer The number's padded length (number of digits).
---@param index integer The index to get digit from.
---@return integer # The digit at the specified index.
ugui.internal.get_digit = function(value, length, index)
    return math.floor(value / math.pow(10, length - index)) % 10
end

---Sets the digit at a specific index in a number with a specific padded length.
---@param value integer The number.
---@param length integer The number's padded length (number of digits).
---@param digit_value integer The new digit value.
---@param index integer The index to get digit from.
---@return integer # The new number.
ugui.internal.set_digit = function(value, length, digit_value, index)
    local old_digit_value = ugui.internal.get_digit(value, length, index)
    local new_value = value + (digit_value - old_digit_value) * math.pow(10, length - index)
    local max = math.pow(10, length)
    return (new_value + max) % max
end

---Sets a range of digits in a padded number.
---@param value integer The number.
---@param length integer The number's padded length.
---@param digits string The digits to insert.
---@param index integer The starting index (1 = leftmost).
---@return integer
ugui.internal.set_digit_range = function(value, length, digits, index)
    local count = #digits
    local digits_value = tonumber(digits)

    local insert_pow = math.pow(10, length - index - count + 1)
    local range_pow = math.pow(10, count)

    -- extract existing digits in that range
    local old_range = math.floor(value / insert_pow) % range_pow

    -- replace them
    local new_value = value + (digits_value - old_range) * insert_pow

    local max = math.pow(10, length)
    return (new_value + max) % max
end

---Remaps a value from one range to another.
---@param value number The value.
---@param from1 number The lower bound of the first range.
---@param to1 number The upper bound of the first range.
---@param from2 number The lower bound of the second range.
---@param to2 number The upper bound of the second range.
---@return number # The new remapped value.
ugui.internal.remap = function(value, from1, to1, from2, to2)
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2
end

---Limits a value to a range.
---@param value number The value.
---@param min number The lower bound.
---@param max number The upper bound.
---@return number # The new limited value.
ugui.internal.clamp = function(value, min, max)
    return math.max(math.min(value, max), min)
end

---Linearly interpolates between two values.
---@param a number
---@param b number
---@param t number
ugui.internal.lerp = function(a, b, t)
    return a + (b - a) * t
end

---Traverses a tree node depth-first and invokes a callback function for each node.
---@param node table The node to traverse.
---@param callback fun(node: SceneNode): boolean? The callback function to invoke for each node. If the callback returns `false`, the traversal is stopped early.
---@param reverse boolean? Whether to traverse children in reverse order.
ugui.internal.foreach_node = function(node, callback, reverse)
    if reverse then
        for i = #node.children, 1, -1 do
            if ugui.internal.foreach_node(node.children[i], callback, reverse) == false then
                return
            end
        end
        if callback(node) == false then
            return
        end
        return
    end

    if callback(node) == false then
        return
    end
    for _, child in ipairs(node.children) do
        if ugui.internal.foreach_node(child, callback) == false then
            return
        end
    end
end

---Traverses the scene depth-first from the root downwards.
---@param callback fun(node: SceneNode): boolean? The callback function to invoke for each node. If the callback returns `false`, the traversal is stopped early.
ugui.internal.foreach_node_from_root = function(callback)
    ugui.internal.foreach_node(ugui.internal.root, callback)
end


---Recursively sorts a scene tree by Z-index, maintaining stable sort order.
---@param node SceneNode
ugui.internal.sort_scene_tree = function(node)
    -- First, recursively sort all children
    for _, child in ipairs(node.children) do
        ugui.internal.sort_scene_tree(child)
    end

    -- Then sort this node's children by Z-index
    ugui.internal.stable_sort(node.children, function(a, b)
        return (a.control.z_index or 0) < (b.control.z_index or 0)
    end)
end

---Sorts controls in the scene tree by their Z-index.
ugui.internal.sort_scene = function()
    ugui.internal.sort_scene_tree(ugui.internal.root)
end

---Returns the control at the given point, if any.
---@param pt Vector2 The point to check for a control.
---@return Control? The control at the given point, or `nil` if no control is found.
ugui.internal.control_from_point = function(pt)
    local result = nil
    ugui.internal.foreach_node_from_root(function(node)
        local control = node.control
        if ugui.internal.is_point_inside_control(pt, control) then
            result = control
            return false
        end
    end)
    return result
end

---Finds a scene node by its control's UID.
---@param uid UID?
---@return SceneNode?
ugui.internal.find_node = function(uid)
    if uid == nil then return nil end
    return ugui.internal.node_by_uid[uid]
end

---Prints the scene tree for debugging purposes.
---@param node SceneNode
ugui.internal.print_tree = function(node)
    ---@param node SceneNode
    local function print_tree_impl(node, prefix, is_last)
        prefix = prefix or ''
        local connector = is_last and '└─ ' or '├─ '

        local label = ''
        if node == ugui.internal.root then
            label = '<root>'
        end
        label = label .. ' ' .. node.type .. ' ' .. tostring(node.control.uid)

        print(prefix .. connector .. label)
        print(prefix .. '      ' .. string.format('rect: (%.0f, %.0f) %.0f x %.0f', node.control.rectangle.x, node.control.rectangle.y, node.control.rectangle.width, node.control.rectangle.height))

        local child_prefix = prefix .. (is_last and '   ' or '│  ')

        local children = node.children or {}
        for i, child in pairs(children) do
            print_tree_impl(child, child_prefix, i == #children)
        end
    end

    print_tree_impl(node)
    print('')
end

---Parses and resolves a SmartUnit expression.
---@param expr string
---@param auto number
---@param parent_basis number
---@return number
local function resolve_unit(expr, auto, parent_basis)
    local function trim(s)
        return (s:gsub('^%s+', ''):gsub('%s+$', ''))
    end

    local function split_args(s)
        local args = {}
        local depth = 0
        local start = 1

        for i = 1, #s do
            local c = s:sub(i, i)

            if c == '(' then
                depth = depth + 1
            elseif c == ')' then
                depth = depth - 1
            elseif c == ',' and depth == 0 then
                table.insert(args, trim(s:sub(start, i - 1)))
                start = i + 1
            end
        end

        table.insert(args, trim(s:sub(start)))

        return args
    end

    local function find_operator(s, operators)
        local depth = 0

        for i = #s, 1, -1 do
            local c = s:sub(i, i)

            if c == ')' then
                depth = depth + 1
            elseif c == '(' then
                depth = depth - 1
            elseif depth == 0 then
                for _, op in ipairs(operators) do
                    if c == op then
                        if op == '-' then
                            local prev = s:sub(i - 1, i - 1)

                            if i == 1 or prev:match('[%+%-%*/%(,]') then
                                goto continue
                            end
                        end

                        return i, op
                    end
                end
            end

            ::continue::
        end
    end

    local function eval(s)
        s = trim(s)

        -- auto
        if s == 'auto' then
            ugui.internal.assert(auto ~= nil, 'auto unit requires auto value')

            return auto
        end

        -- min(...)
        do
            local inner = s:match('^min%((.*)%)$')

            if inner then
                local args = split_args(inner)

                ugui.internal.assert(#args == 2, 'min() expects 2 arguments')

                return math.min(
                    eval(args[1]),
                    eval(args[2])
                )
            end
        end

        -- max(...)
        do
            local inner = s:match('^max%((.*)%)$')

            if inner then
                local args = split_args(inner)

                ugui.internal.assert(#args == 2, 'max() expects 2 arguments')

                return math.max(
                    eval(args[1]),
                    eval(args[2])
                )
            end
        end

        -- clamp(...)
        do
            local inner = s:match('^clamp%((.*)%)$')

            if inner then
                local args = split_args(inner)

                ugui.internal.assert(#args == 3, 'clamp() expects 3 arguments')

                local v = eval(args[1])
                local mn = eval(args[2])
                local mx = eval(args[3])

                return math.max(mn, math.min(mx, v))
            end
        end

        -- parenthesized expression
        if s:match('^%b()$') then
            return eval(s:sub(2, -2))
        end

        -- + -
        do
            local i, op = find_operator(s, {'+', '-'})

            if i then
                local lhs = eval(s:sub(1, i - 1))
                local rhs = eval(s:sub(i + 1))

                return op == '+'
                    and (lhs + rhs)
                    or (lhs - rhs)
            end
        end

        -- * /
        do
            local i, op = find_operator(s, {'*', '/'})

            if i then
                local lhs = eval(s:sub(1, i - 1))
                local rhs = eval(s:sub(i + 1))

                return op == '*'
                    and (lhs * rhs)
                    or (lhs / rhs)
            end
        end

        -- px
        do
            local px = s:match('^([%-%d%.]+)px$')

            if px then
                return tonumber(px)
            end
        end

        -- %
        do
            local percent = s:match('^([%-%d%.]+)%%$')

            if percent then
                return parent_basis * (tonumber(percent) / 100)
            end
        end

        -- zero literal
        if s == '0' then
            return 0
        end

        -- raw number
        do
            local n = tonumber(s)

            if n then
                return n
            end
        end

        ugui.internal.assert(false, string.format('unsupported SmartUnit: %q', s))
    end

    return eval(expr)
end

---Resolves a SmartUnit2 to a Vector2.
---@param unit SmartUnit2
---@param auto Vector2
---@param parent_size Vector2
---@return Vector2
ugui.internal.resolve_unit2 = function(unit, auto, parent_size)
    local a, b = unit:match('^(%S+)%s+(%S+)$')

    if not a then
        a = unit
        b = unit
    end

    return {
        x = resolve_unit(a, auto.x, parent_size.x),
        y = resolve_unit(b, auto.y, parent_size.y),
    }
end

---Parses and resolves a SmartAlignment.
---@param value string
---@param axis '"x"'|'"y"'
---@return number
local function resolve_alignment(value, axis)
    value = value:gsub('^%s+', ''):gsub('%s+$', '')

    -- directional aliases
    if value == 'left' then
        ugui.internal.assert(axis == 'x', '`left` is only valid on the X axis')
        return 0
    end

    if value == 'right' then
        ugui.internal.assert(axis == 'x', '`right` is only valid on the X axis')
        return 1
    end

    if value == 'top' then
        ugui.internal.assert(axis == 'y', '`top` is only valid on the Y axis')
        return 0
    end

    if value == 'bottom' then
        ugui.internal.assert(axis == 'y', '`bottom` is only valid on the Y axis')
        return 1
    end

    if value == 'center' then
        return 0.5
    end

    -- percentage
    do
        local percent = value:match('^([%-%d%.]+)%%$')

        if percent then
            return tonumber(percent) / 100
        end
    end

    -- raw normalized number
    do
        local n = tonumber(value)

        if n then
            return n
        end
    end

    ugui.internal.assert(
        false,
        string.format('unsupported SmartAlignment: %q', value)
    )
end

---Resolves a SmartAlignment2 to a Vector2.
---@param value SmartAlignment2?
---@return Vector2
ugui.internal.resolve_alignment2 = function(value)
    value = value or '0'

    local a, b = value:match('^(%S+)%s+(%S+)$')

    if not a then
        a = value

        -- directional single-value expansion
        if value == 'left' or value == 'right' then
            b = 'top'
        elseif value == 'top' or value == 'bottom' then
            b = value
            a = 'left'
        else
            b = value
        end
    end

    return {
        x = resolve_alignment(a, 'x'),
        y = resolve_alignment(b, 'y'),
    }
end
