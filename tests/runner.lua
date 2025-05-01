--- mupen-lua-ugui test runner
--- https://github.com/Aurumaker72/mupen-lua-ugui

-- FIXME: Strong typing for the test runner!!!

local path_root = debug.getinfo(1).source:sub(2):gsub("\\[^\\]+\\[^\\]+$", "\\")
local test_root = debug.getinfo(1).short_src:gsub("(\\[^\\]+)\\[^\\]+$", "%1\\")

---@module "breitbandgraphics"
BreitbandGraphics = nil

---@module "mupen-lua-ugui"
ugui = nil

local function reset_ugui_state()
    UGUI_QUIET = true
    BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')
    ugui = dofile(path_root .. 'mupen-lua-ugui.lua')
end

reset_ugui_state()

local groups = {
    dofile(test_root .. 'breitbandgraphics.lua'),
    dofile(test_root .. 'numberbox.lua'),
}

local verbose = false
local tests_passed = 0
local tests_failed = 0
local tests_empty = 0

for key, group in pairs(groups) do
    print(string.format('Setting up %s...', group.name or ('test ' .. key)))

    -- Reset the ugui state completely between groups
    reset_ugui_state()

    if group.setup then
        group.setup()
    end

    for _, test in pairs(group.tests) do
        local test_params = test.params and test.params or {0}

        for test_param_index, test_param in pairs(test_params) do
            if not group.keep_state_between_tests then
                reset_ugui_state()
            end

            local assertion_count = 0
            local passed = true
            local messages = {}

            local test_context = {
                data = test_param,
                assert = function(condition, str)
                    assertion_count = assertion_count + 1
                    if condition == false then
                        passed = false
                        messages[# messages + 1] = str
                    end
                end,
                assert_eq = function(expected, actual)
                    assertion_count = assertion_count + 1
                    if expected ~= actual then
                        passed = false
                        messages[# messages + 1] = string.format('Expected %s, got %s', tostring(expected), tostring(actual))
                    end
                end,
                log = function(str)
                    if verbose then
                        print('    [@] ' .. tostring(str))
                    end
                end,
            }

            local success, error_message = pcall(function()
                test.func(test_context)
            end)

            if not success then
                assertion_count = assertion_count + 1
                passed = false
                messages[# messages + 1] = error_message
            end

            if success and test.pass_if_no_error then
                assertion_count = assertion_count + 1
                passed = true
            end

            local name = not test.params and test.name or string.format('%s (%d)', test.name, test_param_index)

            if assertion_count == 0 then
                tests_empty = tests_empty + 1
                print(string.format('    NO ASSERTIONS %s', name))
            else
                if passed then
                    tests_passed = tests_passed + 1
                    print(string.format('    PASS %s', name))
                else
                    tests_failed = tests_failed + 1
                    if #messages > 0 then
                        print(string.format('    FAIL %s:', name))

                        for _, msg in pairs(messages) do
                            print(string.format('      [!] %s', msg))
                        end
                    else
                        print(string.format('    FAIL %s', name))
                    end
                end
            end
        end
    end

    print('')
end

local tests_total = tests_passed + tests_failed + tests_empty

print('Test Summary:')
print(string.format('  Passed: %d', tests_passed))
print(string.format('  Failed: %d', tests_failed))
print(string.format('  Empty: %d', tests_empty))
print(string.format('  Total: %d', tests_total))
print(string.format('  (%d/%d)', tests_passed, tests_total))
