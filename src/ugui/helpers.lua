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
        if #arr <= 1 then return arr end
        local mid = math.floor(#arr / 2)
        local left, right = {}, {}
        for i = 1, mid do table.insert(left, arr[i]) end
        for i = mid + 1, #arr do table.insert(right, arr[i]) end
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
    return string:sub(1, index) .. string2 .. string:sub(index + string2:len(), string:len())
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
